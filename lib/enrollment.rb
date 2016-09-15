class Enrollment

  attr_reader :name, :kindergarten_participation

  def initialize(district_info)
    @name = district_info[:name]
    @kindergarten_participation = district_info[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    participation = kindergarten_participation
    participation.each_pair do |key, value|
      participation[key] = (value*1000).floor/1000.0
    end
  end

  def kindergarten_participation_in_year(year)
    participation = kindergarten_participation_by_year
    participation[year]
  end

end
