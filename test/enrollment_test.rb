require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_enrollment_contains_district_name
    row = {name: "AURORA",
      kindergarten_participation: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)

    assert_equal "AURORA", enroll.name
  end

  def test_enrollment_contains_different_district_name
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)

    assert_equal "ADAMS-ARAPAHOE", enroll.name
  end

  def test_enrollment_contains_kindergarten_participation_statistics
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.99, 2015 => 0.98}}
    enroll = Enrollment.new(row)
    expected = ({2016 => 0.99, 2015 => 0.98})

    assert_equal expected, enroll.kindergarten_participation
  end

  def test_enrollment_contains_different_kindergarten_participation_statistics
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.50, 2015 => 0.55}}
    enroll = Enrollment.new(row)
    expected = ({2016 => 0.50, 2015 => 0.55})

    assert_equal expected, enroll.kindergarten_participation
  end

  def test_enrollment_kindergarten_participation_defaults_to_empty_hash
    row = {name: "ADAMS-ARAPAHOE"}
    enroll = Enrollment.new(row)

    assert_equal ({}), enroll.kindergarten_participation
  end

  def test_kindergarten_participation_by_year_returns_a_hash
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.50, 2015 => 0.55}}
    enroll = Enrollment.new(row)
    expected = ({2016 => 0.50, 2015 => 0.55})

    assert_equal expected, enroll.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_by_year_returns_truncated_numbers
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.5092, 2015 => 0.5575}}
    enroll = Enrollment.new(row)

    assert_equal 0.5092, enroll.kindergarten_participation[2016]
    assert_equal 0.509, enroll.kindergarten_participation_by_year[2016]
  end

  def test_kindergarten_participation_in_year_is_not_destructive
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.5092, 2015 => 0.5575}}
    enroll = Enrollment.new(row)

    assert_equal 0.5092, enroll.kindergarten_participation[2016]
    assert_equal 0.509, enroll.kindergarten_participation_by_year[2016]
    assert_equal 0.5092, enroll.kindergarten_participation[2016]
  end

  def test_kindergarten_participation_in_year_with_included_years
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.502, 2015 => 0.553}}
    enroll = Enrollment.new(row)

    assert_equal 0.502, enroll.kindergarten_participation_in_year(2016)
    assert_equal 0.553, enroll.kindergarten_participation_in_year(2015)
  end

  def test_kindergarten_participation_in_year_invalid_year
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.502, 2015 => 0.553}}
    enroll = Enrollment.new(row)

    assert_equal nil, enroll.kindergarten_participation_in_year(2007)
  end

  def test_enrollment_contains_graduation_rate_statistics
    row = {name: "ADAMS-ARAPAHOE",
      kindergarten_participation: {2016 => 0.502, 2015 => 0.553},
      graduation_rates: {2016 => 0.9942, 2015 => 0.9868}}
    enroll = Enrollment.new(row)

    assert_equal ({2016 => 0.9942, 2015 => 0.9868}), enroll.graduation_rates
  end

  def test_kindergarten_participation_in_year_invalid_year
    row = {name: "ADAMS-ARAPAHOE"}
    enroll = Enrollment.new(row)

    assert_equal ({}), enroll.graduation_rates
  end

  def test_graduation_rate_by_years
    row = {name: "ADAMS-ARAPAHOE",
      graduation_rates: {2016 => 0.5024, 2015 => 0.5522}}
    enroll = Enrollment.new(row)
    expected = ({2016 => 0.502, 2015 => 0.552})

    assert_equal expected, enroll.graduation_rate_by_year
  end

  def test_graduation_rate_in_year
    row = {name: "ADAMS-ARAPAHOE",
      graduation_rates: {2016 => 0.502, 2015 => 0.553}}
    enroll = Enrollment.new(row)

    assert_equal 0.502, enroll.graduation_rate_in_year(2016)
    assert_equal 0.553, enroll.graduation_rate_in_year(2015)
  end

  def test_grad_rate_in_year_invalid_year
    row = {name: "ADAMS-ARAPAHOE",
      graduation_rates: {2016 => 0.502, 2015 => 0.553}}
    enroll = Enrollment.new(row)

    assert_equal nil, enroll.kindergarten_participation_in_year(2007)
  end

end
