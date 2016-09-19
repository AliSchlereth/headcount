require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_district_contains_district_name
    row = {name: "AURORA"}
    district = District.new(row)
    
    assert_equal "AURORA", district.name
  end

  def test_district_contains_different_district_name
    row = {name: "ADAMS-ARAPAHOE 28J"}
    district = District.new(row)

    assert_equal "ADAMS-ARAPAHOE 28J", district.name
  end

  def test_district_can_hold_enrollment_data
    row = {enrollment: "some data"}
    district = District.new(row)

    assert_equal "some data", district.enrollment
  end

  # test district contains an enrollment object

  def test_district_can_hold_statewide_data
    row = {statewide_testing: "some data"}
    district = District.new(row)

    assert_equal "some data", district.statewide_test
  end

  # test district contains a statewide test object

  def test_district_can_hold_economic_profile_data
    row = {economic_profile: "some data"}
    district = District.new(row)

    assert_equal "some data", district.economic_profile
  end

end
