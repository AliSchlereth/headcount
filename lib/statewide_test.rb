class StatewideTest
  attr_reader :name, :third_grade

  def initialize(district_info)
    @name = district_info[:name]
    @third_grade = district_info[:third_grade]
  end

end
