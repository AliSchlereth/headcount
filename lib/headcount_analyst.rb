require_relative 'district_repository'
require_relative 'headcount_calculator'
require_relative 'headcount_error'

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repository)
    @district_repo = district_repository
  end

  def calculate_district_average(district_name, data_type)
    district    = district_repo.find_by_name(district_name)
    percentages = district.enrollment.send(data_type).values
    percentages.reduce(:+)/percentages.length
  end

  def kindergarten_participation_rate_variation(d1, d2)
    d2     = d2[:against]
    d1_avg = calculate_district_average(d1.upcase, "kindergarten_participation")
    d2_avg = calculate_district_average(d2.upcase, "kindergarten_participation")
    HeadcountCalculator.truncate(d1_avg/d2_avg)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_1     = district_repo.find_by_name(district_1.upcase)
    district_2     = district_repo.find_by_name(district_2[:against].upcase)
    d1_percentages = district_1.enrollment.kindergarten_participation
    d2_percentages = district_2.enrollment.kindergarten_participation
    compare_yearly_percentages(d1_percentages, d2_percentages)
  end

  def compare_yearly_percentages(d1_percents, d2_percents)
    d1_percents.reduce({}) do |output, (year, percent)|
      output[year] = HeadcountCalculator.truncate(percent/d2_percents[year])
      output
    end
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder = calculate_district_average(district, "kindergarten_participation")
    grad = calculate_district_average(district, "graduation_rates")
    sw_kinder_data = calculate_district_average("COLORADO",
                                                "kindergarten_participation")
    sw_grad_data = calculate_district_average("COLORADO", "graduation_rates")
    calculate_variance(kinder,grad, sw_kinder_data, sw_grad_data)
  end

  def calculate_variance(kinder_data, grad_data, sw_kinder_data, sw_grad_data)
    kinder_variance = kinder_data/sw_kinder_data
    grad_variance = grad_data/sw_grad_data
    return 0 if grad_variance == 0
    HeadcountCalculator.truncate(kinder_variance/grad_variance)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(relate)
    result = district_correlation(relate[:for])          if relate.key?(:for)
    result = multi_district_correlation(relate[:across]) if relate.key?(:across)
    result
  end

  def district_correlation(relate)
    if relate.upcase == "STATEWIDE"
      calculate_statewide_correlation
    else
      vari = kindergarten_participation_against_high_school_graduation(relate)
      vari >= 0.6 && vari <= 1.5
    end
  end

  def calculate_statewide_correlation
    check_correlation(district_repo.districts)
  end

  def multi_district_correlation(districts)
    check_correlation(districts)
  end

  def check_correlation(districts)
    result = group_by_correlation(districts)
    result[true].nil?  ? trues = 0  : trues  = result[true].count
    result[false].nil? ? falses = 0 : falses = result[false].count
    (trues / (trues + falses)) >= 0.70
  end

  def group_by_correlation(districts)
    districts.group_by do |(name, _)|
      district_correlation(name)
    end
  end

  def top_statewide_test_year_over_year_growth(input)
    error_message("no grade", input)                      if input[:grade].nil?
    error_message(:grade, input)    if input[:grade] != 8 && input[:grade] != 3
    sorted = search_top_growth_by_subj(input)      if input[:subject]
    sorted = search_for_top_growth_all_subjects(input)    unless input[:subject]
    return sorted.reverse[0..(input[:top]-1)]             if input[:top]
    sorted[-1]
  end

  def search_top_growth_by_subj(input, weight = 1)
    statewide_test_data = @district_repo.statewide_repo.statewide_tests
    growths = find_growths(input, statewide_test_data, weight)
    cleaned_growths = growths.reject {|district| district[-1].nan?}
    sorted = cleaned_growths.sort_by {|district| district[-1]}
  end

  def find_growths(input, statewide_test_data, weight)
     statewide_test_data.reduce([]) do |result, (name, district)|
      min = find_minimum_year_data(name, district, input)
      max = find_maximum_year_data(name, district, input)
      result << [name, ((max[-1] - min[-1]) / (max[1] - min[1]))*weight] unless
            min[-1].nil? || max[-1].nil?
      result
    end
  end

  def find_minimum_year_data(name, district, input)
    testing_data = district.proficient_by_grade(input[:grade])
    testing_data.reduce([]) do |result, (year, scores)|
      result = [name, year, scores[input[:subject]]] if
            (result.empty? || year < result[1]) && scores[input[:subject]] != 0
      result
    end
  end

  def find_maximum_year_data(name, district, input)
    testing_data = district.proficient_by_grade(input[:grade])
    testing_data.reduce([]) do |result, (year, scores)|
      result = [name, year, scores[input[:subject]]] if
            (result.empty? || year > result[1]) && scores[input[:subject]] != 0
      result
    end
  end

  def search_for_top_growth_all_subjects(input)
    subjects = [:math, :reading, :writing]
    all_subject_growths = find_all_subject_growths(input, subjects)
    organized = organize_all_subjects_growths(all_subject_growths)
  end

  def find_all_subject_growths(input, subjects)
    subjects.reduce([]) do |result, subject|
      input[:subject] = subject
      weight = assign_weight(input)
      search_top_growth_by_subj(input, weight).each {|growth| result << growth}
      result
    end
  end

  def assign_weight(input)
    if input[:weighting].nil?
      weight = 0.33
    else
      weight = input[:weighting][input[:subject]]
    end
  end

  def organize_all_subjects_growths(all_subject_growths)
    grouped = all_subject_growths.group_by {|district_info| district_info[0]}
    compiled = grouped.map do |name, growth_all_subjects|
      grouped[name] = compile_all_growths(growth_all_subjects)
      [name, grouped[name]]
    end
    compiled.sort_by {|district_info| district_info[-1]}
  end

  def compile_all_growths(growth_all_subjects)
    growth_all_subjects.reduce(0) do |result, subject_data|
      result += subject_data[-1]
      result
    end
  end

  def error_message(message, data)
    if message == "no grade"
      raise InsufficientInformationError,
        "A grade must be provided to answer this question"
  elsif message == :grade
      raise UnknownDataError,
        "#{data[message]} is not a known grade"
    end
  end


end
