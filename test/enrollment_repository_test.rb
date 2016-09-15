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

  def test_can_pass_graduation_data_to_enrollment
    er = EnrollmentRepository.new
    row = {location: "ADAMS-ARAPAHOE", timeframe: 2016, data: 0.502
    graduation_rates: {2016 => 0.99, 2015 => 0.98}}
    er.create_enrollment_object(row)

    assert_equal ({2016 => 0.99, 2015 => 0.98}), er.enrollments["ADAMS-ARAPAHOE"].graduation_rates
  end

end
