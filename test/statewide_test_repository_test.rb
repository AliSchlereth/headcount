require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_statewide_repository_loads_from_a_hash
    str = StatewideTestRepository.new
    data = {:statewide_testing => {
              :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
            }}
    assert_instance_of Hash, str.load_data(data)
  end

  def test_repository_has_once_instance_for_each_district
    str = StatewideTestRepository.new
    data = {:statewide_testing => {
              :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
            }}
    str.load_data(data)
    assert_equal 1, str.statewide_tests.keys.count("COLORADO")
  end

  def test_can_create_statewide_object_with_any_data_type
    #need to change row text fixture to include "score-math,readin,writing.."
    str = StatewideTestRepository.new
    row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
    assert_instance_of StatewideTest, str.create_obj_by_grade(row, :third_grade)
  end

  def test_can_add_to_existing_object
    str = StatewideTestRepository.new

    row1 = {location: "ADAMS-ARAPAHOE", timeframe: 2008, score: "Math", data: 0.555 }
    row2 = {location: "ADAMS-ARAPAHOE", timeframe: 2009, score: "Math", data: 0.665 }
    str.create_statewide_object(row1, :third_grade)
    expected = ({2008=>{:math=>0.555}, 2009=>{:math=>0.665}})
    str.add_to_statewide_object(row2, :third_grade)
    assert_equal expected, str.statewide_tests["ADAMS-ARAPAHOE"].third_grade
  end

  def test_can_load_multiple_files_at_once
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
      :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
      :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv" }})
    expected_1 = {:math=>0.473, :reading=>0.466, :writing=>0.339}
    expected_2 = {:math=>0.32, :reading=>0.456, :writing=>0.265}

    assert_equal (expected_1), str.statewide_tests["ADAMS-ARAPAHOE 28J"].third_grade[2008]
    assert_equal (expected_2), str.statewide_tests["ADAMS-ARAPAHOE 28J"].eighth_grade[2008]
  end

  # add test for check for statewide object method

  def test_can_create_statewide_object_for_math
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
        :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math short.csv"}})

    assert_equal ({2011=>0.68, 2012=>0.6894, 2013=>0.69683, 2014=>0.69944}),  str.statewide_tests["ACADEMY 20"].math[:all_students]
  end

  def test_can_create_statewide_object_for_reading
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
        :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading short.csv"}})

    assert_equal ({2011=>0.83, 2012=>0.84585, 2013=>0.84505, 2014=>0.84127}),  str.statewide_tests["ACADEMY 20"].reading[:all_students]
  end

  def test_can_create_statewide_object_for_writing
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
        :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing short.csv"}})

    assert_equal ({2011=>0.7192, 2012=>0.70593, 2013=>0.72029, 2014=>0.71583}),  str.statewide_tests["ACADEMY 20"].writing[:all_students]
  end

  def test_can_load_all_files_at_once
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv",
                  :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math short.csv",
                  :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading short.csv",
                  :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing short.csv"
                }})
    expected_1 = {:math=>0.473, :reading=>0.466, :writing=>0.339}
    expected_2 = {:math=>0.32, :reading=>0.456, :writing=>0.265}
    expected_3 = {2011=>0.38, 2012=>0.37735, 2013=>0.3733, 2014=>0.35927}
    expected_4 = {2011=>0.47, 2012=>0.48299, 2013=>0.48395, 2014=>0.46483}
    expected_5 = {2011=>0.3429, 2012=>0.35533, 2013=>0.35625, 2014=>0.34175}

    assert_equal (expected_1), str.statewide_tests["ADAMS-ARAPAHOE 28J"].third_grade[2008]
    assert_equal (expected_2), str.statewide_tests["ADAMS-ARAPAHOE 28J"].eighth_grade[2008]
    assert_equal (expected_3), str.statewide_tests["ADAMS-ARAPAHOE 28J"].math[:all_students]
    assert_equal (expected_4), str.statewide_tests["ADAMS-ARAPAHOE 28J"].reading[:all_students]
    assert_equal (expected_5), str.statewide_tests["ADAMS-ARAPAHOE 28J"].writing[:all_students]
  end

  def test_can_return_proficiency_for_grades_3_and_8
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
      :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
      :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv" }})
    statewide = str.find_by_name("Academy 20")
    expected_1 = {:math=>0.857, :reading=>0.866, :writing=>0.671}
    expected_2 = {:math=>0.64, :reading=>0.843, :writing=>0.734}

    assert_equal (expected_1), statewide.proficient_by_grade(3)[2008]
    assert_equal (expected_2), statewide.proficient_by_grade(8)[2008]
  end

  def test_can_return_unknown_data_error_for_nil_grade
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
      :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"}})
    statewide = str.find_by_name("Academy 20")

    assert_raises (UnknownDataError) do
      statewide.proficient_by_grade(9)
    end
  end

  def test_can_return_proficiency_for_asian_students
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math short.csv",
                  :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading short.csv",
                  :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing short.csv"
                }})
    statewide = str.find_by_name("academy 20")
    expected = {:math=>0.818, :reading=>0.893, :writing=>0.808}

    assert_equal (expected), statewide.proficient_by_race_or_ethnicity(:asian)[2012]
  end

  def test_can_return_unknown_data_error_for_nil_race
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math short.csv",
                  :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading short.csv",
                  :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing short.csv"
                }})
    statewide = str.find_by_name("academy 20")

    assert_raises (UnknownDataError) do
      statewide.proficient_by_race_or_ethnicity(:troll)
    end
  end

  def test_proficient_for_subject_by_grade_in_year
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv"
                }})
    statewide = str.find_by_name("academy 20")

    assert_equal 0.857, statewide.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_can_return_unknown_data_error_for_subject_by_grade_in_year
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv"
                }})
    statewide = str.find_by_name("academy 20")

    assert_raises (UnknownDataError) do
      statewide.proficient_for_subject_by_grade_in_year(:drama, 3, 2008)
    end
    assert_raises (UnknownDataError) do
      statewide.proficient_for_subject_by_grade_in_year(:math, 4, 2008)
    end
  end

  def test_proficient_for_subject_by_race_in_year
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math short.csv",
                  :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading short.csv",
                  :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing short.csv"
                }})
    statewide = str.find_by_name("academy 20")

    assert_equal 0.816, statewide.proficient_for_subject_by_race_in_year(:math, :asian, 2011)
  end

  def test_can_return_unknown_data_error_for_subject_by_race_in_year
    str = StatewideTestRepository.new
    str.load_data({
                :statewide_testing => {
                  :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math short.csv",
                  :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading short.csv",
                  :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing short.csv"
                }})
    statewide = str.find_by_name("academy 20")
    assert_raises (UnknownDataError) do
      statewide.proficient_for_subject_by_race_in_year(:math, :troll, 2011)
    end
    assert_raises (UnknownDataError) do
      statewide.proficient_for_subject_by_race_in_year(:drama, :asian, 2011)
    end
    assert_raises (UnknownDataError) do
      statewide.proficient_for_subject_by_race_in_year(:math, :asian, 1937)
    end
  end

end
