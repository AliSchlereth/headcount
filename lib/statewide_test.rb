require 'headcount_error'

class StatewideTest
  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing

  def initialize(district_info)
    @name = district_info[:name]
    @third_grade = set_empty_hash_if_nil(district_info[:third_grade])
    @eighth_grade = set_empty_hash_if_nil(district_info[:eighth_grade])
    @math = set_empty_hash_if_nil(district_info[:math])
    @reading = set_empty_hash_if_nil(district_info[:reading])
    @writing = set_empty_hash_if_nil(district_info[:writing])
  end

  def set_empty_hash_if_nil(info)
    info.nil? ? {} : info
  end

  def proficient_by_grade(grade)
    return third_grade if grade == 3
    return eighth_grade if grade == 8
    raise UnknownDataError unless grade == 3 || grade == 8
  end

end
