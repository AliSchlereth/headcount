require_relative 'headcount_calculator'

class Enrollment

  attr_reader :name, :kindergarten_participation, :graduation_rates

  def initialize(district_info)
    @name = district_info[:name]
    @kindergarten_participation = district_info[:kindergarten_participation]
    @graduation_rates = district_info[:graduation_rates]
  end

  def kindergarten_participation_by_year
    participation = kindergarten_participation.dup
    participation.each_pair do |key, value|
      participation[key] = HeadcountCalculator.truncate(value)
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

end
