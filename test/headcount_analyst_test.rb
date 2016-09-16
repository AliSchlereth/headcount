require './test/test_helper'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def test_headcount_analyst_initialized_with_district_repo
    ha = HeadcountAnalyst.new(DistrictRepository.new)
    assert_instance_of DistrictRepository, ha.district_repo
  end

  def test_can_access_specific_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)

    assert_equal "ACADEMY 20", ha.district_repo.find_by_name("ACADEMY 20").name
  end

  def test_can_access_enrollment_data_for_a_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    district = ha.district_repo.find_by_name("ACADEMY 20")

    assert_equal 0.391, district.enrollment.kindergarten_participation_in_year(2007)
  end

  def test_calculates_participation_average_for_a_district
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.4064509090909091, ha.calculate_district_average("Academy 20", "kindergarten_participation")
  end

  def test_calculates_participation_rate_variation
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  end

  def test_calculates_kindergarten_participation_rate_variation_trend
    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.992, ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')[2007]
  end

  def test_compares_kindergarten_vs_graduation_rates
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }})
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
  end

  def test_correlation_between_high_school_and_kindergarten
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }})
    ha = HeadcountAnalyst.new(dr)

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_statewide_correlation_between_kinder_and_high_school
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
  end

  def test_multi_district_correlation_between_kinder_and_high_school
    dr = DistrictRepository.new
    dr.load_data({ :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv"
    }})
    ha = HeadcountAnalyst.new(dr)

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(across: ['DENVER COUNTY 1', "ADAMS-ARAPAHOE 28J", "ACADEMY 20", "BYERS 32J"])
  end





end
