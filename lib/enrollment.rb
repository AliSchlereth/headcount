class Enrollment

  attr_reader :name, :kindergarten_participation

  def initialize(district_info)
    @name = district_info[:name]
    @kindergarten_participation = district_info[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
      @kindergarten_participation.each_pair do |key, value|
        # require 'pry'; binding.pry
      kindergarten_participation[key] = value.to_f.round(3)
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year
    require 'pry'; binding.pry
    kindergarten_participation[year]
  end

end
