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
    district_1_avg = calculate_district_average(
        district_1.upcase, "kindergarten_participation")
    district_2_avg = calculate_district_average(
        district_2.upcase, "kindergarten_participation")
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
    result = d1_percentages.reduce({}) do |output, (year, percentage)|
      output[year] = HeadcountCalculator.truncate(percentage/d2_percentages[year])
      output
    end
    result
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kinder_data = calculate_district_average(
        district, "kindergarten_participation")
    grad_data   = calculate_district_average(district, "graduation_rates")
    statewide_kinder_data = calculate_district_average(
        "COLORADO", "kindergarten_participation")
    statewide_grad_data = calculate_district_average(
        "COLORADO", "graduation_rates")
    calculate_variance(kinder_data,grad_data, statewide_kinder_data,
                        statewide_grad_data)
  end
  # create a hash to pass through so many variables
  # consider changing method calculate district average to be
  #    shorter for line length

  def calculate_variance(kinder_data,grad_data, statewide_kinder_data,
                        statewide_grad_data)
    kinder_variance = kinder_data/statewide_kinder_data
    grad_variance = grad_data/statewide_grad_data
    return 0 if grad_variance == 0
    HeadcountCalculator.truncate(kinder_variance/grad_variance)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(relate)
    result = district_correlation(relate[:for]) if relate.key?(:for)
    result = multi_district_correlation(relate[:across]) if relate.key?(:across)
    result
  end

  def district_correlation(relate)
    if relate.upcase == "STATEWIDE"
      calculate_statewide_correlation
    else
      # consider changing variation to range? Used vari for now
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
    trues = result[true].count
    falses = result[false].count
    (trues / (trues + falses)) >= 0.70
  end

  def group_by_correlation(districts)
    districts.group_by do |(name, _)|
      district_correlation(name)
    end
  end


end
