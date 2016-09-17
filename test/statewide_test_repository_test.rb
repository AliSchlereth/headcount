require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  # def test_statewide_repository_loads_from_a_hash
  #   str = StatewideTestRepository.new
  #   data = {:statewide_testing => {
  #             :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
  #           }}
  #   assert_instance_of Hash, str.load_data(data)
  # end
  #
  # def test_repository_has_once_instance_for_each_district
  #   str = StatewideTestRepository.new
  #   data = {:statewide_testing => {
  #             :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
  #           }}
  #   str.load_data(data)
  #   assert_equal 1, str.statewide_tests.keys.count("COLORADO")
  # end
  #
  # def test_can_create_statewide_object_with_any_data_type
  #   #need to change row text fixture to include "score-math,readin,writing.."
  #   str = StatewideTestRepository.new
  #   row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
  #   assert_instance_of StatewideTest, str.create_statewide_object(row, :third_grade)
  # end
  #
  # def test_can_add_to_existing_object
  #   skip
  #   #need to change row text fixture to include "score-math,readin,writing.."
  #   str = StatewideTestRepository.new
  #   row1 = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
  #   row2 = {location: "ADAMS-ARAPAHOE", timeframe: 2007, data: 0.502}
  #   str.create_statewide_object(row1, :third_grade)
  #   expected = ({2016 => 0.502, 2007 => 0.502})
  #   str.add_to_statewide_object(row2, :third_grade)
  #   assert_equal expected, str.statewide_tests["ADAMS-ARAPAHOE"].third_grade
  # end

  def test_can_load_multiple_files_at_once
    str = StatewideTestRepository.new
    str.load_data({ :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv" }})
    expected_1 = {"Math"=>0.473, "Reading"=>0.466, "Writing"=>0.339}
    expected_2 = {"Math"=>0.32, "Reading"=>0.456, "Writing"=>0.265}

    assert_equal (expected_1), str.statewide_tests["ADAMS-ARAPAHOE 28J"].third_grade[2008]
    assert_equal (expected_2), str.statewide_tests["ADAMS-ARAPAHOE 28J"].eighth_grade[2008]
  end

  # add test for check for statewide object method


end
