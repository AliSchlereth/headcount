require_relative 'district_repository'
require_relative 'headcount_calculator'

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repository)
    @district_repo = district_repository
  end

  def calculate_district_average(district_name, data_type)
    district = district_repo.find_by_name(district_name)
    percentages = district.enrollment.send(data_type).values
    percentages.reduce(:+)/percentages.length
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_2 = district_2[:against]
    district_1_avg = calculate_district_average(district_1.upcase, "kindergarten_participation")
    district_2_avg = calculate_district_average(district_2.upcase, "kindergarten_participation")
    HeadcountCalculator.truncate(district_1_avg/district_2_avg)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    district_1 = district_repo.find_by_name(district_1.upcase)
    district_2 = district_repo.find_by_name(district_2[:against].upcase)
    d1_percentages = district_1.enrollment.kindergarten_participation
    d2_percentages = district_2.enrollment.kindergarten_participation
    compare_yearly_percentages(d1_percentages, d2_percentages)
  end

  def compare_yearly_percentages(d1_percentages, d2_percentages)
    output = {}
    d1_percentages.each do |year, percentage|
      output[year] = HeadcountCalculator.truncate(percentage/d2_percentages[year])
    end
    output
  end

  def kindergarten_participation_against_high_school_graduation(district_input)
    kinder_data = calculate_district_average(district_input, "kindergarten_participation")
    grad_data   = calculate_district_average(district_input, "graduation_rates")
    statewide_kinder_data = calculate_district_average("COLORADO", "kindergarten_participation")
    statewide_grad_data = calculate_district_average("COLORADO", "graduation_rates")
    calculate_variance(kinder_data,grad_data, statewide_kinder_data, statewide_grad_data)
  end

  def calculate_variance(kinder_data,grad_data, statewide_kinder_data, statewide_grad_data)
    kinder_variance = kinder_data/statewide_kinder_data
    grad_variance = grad_data/statewide_grad_data
    return 0 if grad_variance == 0
    HeadcountCalculator.truncate(kinder_variance/grad_variance)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(correlate)
    result = find_district_correlation(correlate[:for]) if correlate.key?(:for)
    result = find_multi_district_correlation(correlate[:across]) if correlate.key?(:across)
    result
  end

  def find_district_correlation(correlate)
    if correlate.upcase == "STATEWIDE"
      calculate_statewide_correlation
    else
      variation = kindergarten_participation_against_high_school_graduation(correlate)
      variation >= 0.6 && variation <= 1.5
    end
  end

  def calculate_statewide_correlation
    true_count = 0.0
    false_count = 0.0
    district_repo.districts.each do |district_name, _|
      find_district_correlation(district_name) ? true_count += 1 : false_count += 1
    end
    (true_count / (true_count + false_count)) >= 0.70
  end

  def find_multi_district_correlation(districts)
    true_count = 0.0
    false_count = 0.0
    districts.each do |district_name, _|
      find_district_correlation(district_name) ? true_count += 1.0 : false_count += 1.0
    end
    (true_count / (true_count + false_count)) >= 0.70
  end





end
