require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repository)
    @district_repo = district_repository
  end

  def calculate_district_average(district_name)
    district = district_repo.find_by_name(district_name.upcase)
    percentages = district.enrollment.kindergarten_participation.values
    percentages.reduce(:+)/percentages.length
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_2 = district_2[:against]
    district_1_avg = calculate_district_average(district_1)
    district_2_avg = calculate_district_average(district_2)
    ((district_1_avg/district_2_avg)*1000).floor/1000.0
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
        output[year] = ((percentage/d2_percentages[year])*1000).floor/1000.0
      end
      output
      require "pry"; binding.pry
    end

end
