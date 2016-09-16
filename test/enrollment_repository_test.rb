require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_enrollment_repository_loads_from_a_hash
    er = EnrollmentRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    er.load_data(data)

    assert_instance_of Hash, er.load_data(data)
  end
  # could add mock to prove that load data calls on symbol translator

  def test_symbol_translator_returns_correlated_symbol
    er = EnrollmentRepository.new

    assert_equal :kindergarten_participation, er.symbol_translator(:kindergarten)
    assert_equal :graduation_rates, er.symbol_translator(:high_school_graduation)
  end

  def test_repository_has_one_instance_for_each_district
    er = EnrollmentRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    er.load_data(data)

    assert_equal 1, er.enrollments.keys.count("COLORADO")
  end

  # def test_check_for_enrollment_object_calls_add_to_enrollment_object
  #   this would be a mock, call check for enrollment object
  #    send to add to enrollment objec
  # end

  # write another mock to send to create enrollment object

  def test_can_create_enrollment_object_with_any_data_type
    er = EnrollmentRepository.new
    row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}

    assert_instance_of Enrollment, er.create_enrollment_object(row, :kindergarten_participation)
  end

  def test_can_add_to_existing_object
    er = EnrollmentRepository.new
    row1 = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
    row2 = {location: "ADAMS-ARAPAHOE", timeframe: 2007, data: 0.502}
    expected = ({2016 => 0.502, 2007 => 0.502})

    er.create_enrollment_object(row1, :kindergarten_participation)
    er.add_to_enrollment_object(row2, :kindergarten_participation)

    assert_equal expected, er.enrollments["ADAMS-ARAPAHOE"].kindergarten_participation
  end

  def test_find_by_name_returns_an_enrollment_object
    er = EnrollmentRepository.new
    er.load_data({ :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }})

    assert_instance_of Enrollment, er.find_by_name("ACADEMY 20")
  end

  def test_find_by_name_returns_correct_enrollment_object
    er = EnrollmentRepository.new
    er.load_data({ :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }})

    assert_equal "ACADEMY 20", er.find_by_name("ACADEMY 20").name
  end

  def test_can_pass_graduation_data_to_enrollment
    er = EnrollmentRepository.new
    row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
    er.create_enrollment_object(row, :graduation_rates)

    assert_equal ({2016 => 0.502}), er.enrollments["ADAMS-ARAPAHOE"].graduation_rates
  end

  def test_can_load_two_files_with_different_data
    er = EnrollmentRepository.new
    er.load_data({ :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
        }})
    enrollment = er.find_by_name("ACADEMY 20")
    assert_instance_of Enrollment, er.enrollments["ACADEMY 20"]
  end

end
