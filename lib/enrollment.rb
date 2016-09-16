require_relative 'headcount_calculator'

class Enrollment

  attr_reader :name, :kindergarten_participation, :graduation_rates

  def initialize(district_info)
    @name = district_info[:name]
    @kindergarten_participation = set_empty_hash_if_nil(
      district_info[:kindergarten_participation])
    @graduation_rates = set_empty_hash_if_nil(district_info[:graduation_rates])
  end

  # Possibly change method name due to line length
  def set_empty_hash_if_nil(info)
    info.nil? ? {} : info
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

  def graduation_rate_by_year
    participation = graduation_rates.dup
    participation.each_pair do |key, value|
      participation[key] = HeadcountCalculator.truncate(value)
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

end
