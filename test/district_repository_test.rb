require './test/test_helper'
require './lib/district_repository'

class DistrictRepostoryTest < Minitest::Test

  def test_load_data_takes_a_hash_for_loading
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}

    assert_instance_of Hash, dr.load_data(data)
  end

  def test_parse_for_district_creates_district_objects
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}

    assert_instance_of District, dr.load_data(data).values[0]
  end

  def test_parse_for_district_only_creates_one_instance_for_each_district
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}

    assert_equal 1, dr.load_data(data).keys.count("COLORADO")
  end

  def test_user_can_search_by_name
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of District, dr.find_by_name("COLORADO")
    assert_equal "ACADEMY 20", dr.find_by_name("Academy 20").name
    assert_equal nil, dr.find_by_name("ELMO")
  end

  def test_user_can_search_by_substring_of_name
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of Array, dr.find_all_matching("ADAMS")
    assert_equal 2, dr.find_all_matching("ADAMS").count
  end

  def test_district_repo_initialized_with_enrollment_repo
    dr = DistrictRepository.new
    assert_instance_of EnrollmentRepository, dr.enrollment_repo
  end

  def test_load_data_can_populate_enrollment_repo
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}

    assert_equal 0, dr.enrollment_repo.enrollments.count

    dr.load_data(data)

    assert_equal 181, dr.enrollment_repo.enrollments.count
  end

  def test_district_contains_correct_enrollment_object
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)

    assert_instance_of Enrollment, dr.districts.values[0].enrollment
  end

  def test_enrollment_methods_available_through_district_repo
    dr = DistrictRepository.new
    data = {:enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
    }}
    dr.load_data(data)
    district = dr.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end
end
