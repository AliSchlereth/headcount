require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_contains_district_name
    row = {name: "AURORA", kindergarten_participation: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)
    assert_equal "AURORA", enroll.name
  end

  def test_enrollment_contains_different_district_name
    row = {name: "ADAMS-ARAPAHOE", kindergarten_participation: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)
    assert_equal "ADAMS-ARAPAHOE", enroll.name
  end

  def test_enrollment_contains_kindergarten_participation_statistics
    row = {name: "ADAMS-ARAPAHOE", kindergarten_participation: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)
    assert_equal ({2016 => 0.99, 2015 => 0.98}), enroll.kindergarten_participation
  end

  def test_enrollment_contains_different_kindergarten_participation_statistics
    row = {name: "ADAMS-ARAPAHOE", kindergarten_participation: {2016 => 0.50, 2015 => 0.55}}
    enroll = Enrollment.new(row)
    assert_equal ({2016 => 0.50, 2015 => 0.55}), enroll.kindergarten_participation
  end

  def test_kindergarten_participation_by_year_returns_a_hash
    row = {name: "ADAMS-ARAPAHOE", kindergarten_participation: {2016 => 0.50, 2015 => 0.55}}
    enroll = Enrollment.new(row)
    assert_instance_of Hash, enroll.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year
    row = {name: "ADAMS-ARAPAHOE", kindergarten_participation: {2016 => 0.502, 2015 => 0.553}}
    enroll = Enrollment.new(row)
    assert_equal 0.502, enroll.kindergarten_participation_in_year(2016)
    assert_equal 0.553, enroll.kindergarten_participation_in_year(2015)
  end

  def test_enrollment_contains_graduation_rate_statistics
    row = {name: "ADAMS-ARAPAHOE", kindergarten_participation: {2016 => 0.502, 2015 => 0.553},
    graduation_rates: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)
    assert_equal ({2016 => 0.99, 2015 => 0.98}), enroll.graduation_rates
  end






end
