require_relative 'headcount_error'
require_relative 'headcount_calculator'

class StatewideTest
  RACES = [:asian, :black, :pacific_islander, :hispanic, :native_american,
           :two_or_more, :white]
  SUBJECTS = [:math, :reading, :writing]

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

  def proficient_for_subject_by_grade_in_year(subj, grade, year)
    raise UnknownDataError unless grade == 3 || grade == 8
    raise UnknownDataError unless SUBJECTS.include?(subj)
    return "N/A" if third_grade[year][subj].zero? ||
                    eighth_grade[year][subj].zero?
    return HeadcountCalculator.truncate(third_grade[year][subj]) if grade == 3
    return HeadcountCalculator.truncate(eighth_grade[year][subj]) if grade == 8
  end

  def proficient_for_subject_by_race_in_year(subj, race, year)
    raise UnknownDataError unless RACES.include?(race)
    raise UnknownDataError unless SUBJECTS.include?(subj)
    raise UnknownDataError if math[race][year].nil? ||
                           reading[race][year].nil? ||
                           writing[race][year].nil?
    return HeadcountCalculator.truncate(math[race][year]) if subj == :math
    return HeadcountCalculator.truncate(reading[race][year]) if subj == :reading
    return HeadcountCalculator.truncate(writing[race][year]) if subj == :writing
  end

end
