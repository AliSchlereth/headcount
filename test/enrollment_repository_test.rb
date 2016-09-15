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

  def test_repository_has_once_instance_for_each_district
    er = EnrollmentRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    er.load_data(data)

    assert_equal 1, er.enrollments.keys.count("COLORADO")
  end

  def test_can_create_enrollment_object_with_any_data_type
    er = EnrollmentRepository.new
    row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}

    assert_instance_of Enrollment, er.create_enrollment_object(row, :kindergarten_participation)
  end

  def test_can_add_to_existing_object
    er = EnrollmentRepository.new
    row1 = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
    row2 = {location: "ADAMS-ARAPAHOE", timeframe: 2007, data: 0.502}
    er.create_enrollment_object(row1, :kindergarten_participation)
    expected = ({2016 => 0.502, 2007 => 0.502})
    er.add_to_enrollment_object(row2, :kindergarten_participation)

    assert_equal expected, er.enrollments["ADAMS-ARAPAHOE"].kindergarten_participation
  end

  def test_can_pass_graduation_data_to_enrollment
    er = EnrollmentRepository.new
    row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502}
    er.create_enrollment_object(row, :graduation_rates)

    assert_equal ({2016 => 0.502}), er.enrollments["ADAMS-ARAPAHOE"].graduation_rates
  end

end
