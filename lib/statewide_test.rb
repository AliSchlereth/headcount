require 'headcount_error'
require_relative 'headcount_calculator'

class StatewideTest
  RACES = [:asian, :black, :pacific_islander, :hispanic, :native_american,
           :two_or_more, :white]

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
    return HeadcountCalculator.truncate_data(third_grade.dup) if grade == 3
    return HeadcountCalculator.truncate_data(eighth_grade.dup) if grade == 8
    raise UnknownDataError unless grade == 3 || grade == 8
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownDataError unless RACES.include?(race)
    result = {}
    subjects = [[math, :math], [reading, :reading] , [writing, :writing]]
    subjects.each do |subject|
      load_subjects(subject[0], race, result, subject[-1])
    end
    result
  end

  def load_subjects(data, race, result, subject)
    data[race].each do |year, percent|
      if result[year].nil?
        result[year] = {subject => HeadcountCalculator.truncate(percent)}
      else
        result[year].merge!({subject => HeadcountCalculator.truncate(percent)})
      end
    end
  end

end
