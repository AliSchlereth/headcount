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

end
