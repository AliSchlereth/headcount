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

  def test_error_message_raises_errors
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)


    assert_raises (InsufficientInformationError) do
      ha.error_message("no grade", {subject: :math})
    end
    assert_raises (UnknownDataError) do
      ha.error_message(:grade, {subject: :math})
    end
  end

  def test_can_top_statewide_year_over_year_returns_error_for_invalid_data
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)

    assert_raises (InsufficientInformationError) do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_can_top_statewide_year_over_year_returns_error_for_invalid_data
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)

    assert_raises (UnknownDataError) do
      ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
    end
  end
  
  def test_can_top_statewide_year_over_year_returns_district_name_and_growth
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv",
                  :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = ["ADAMS-ARAPAHOE 28J", 0.0043333333333333375]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end

  def test_can_top_statewide_year_over_year_returns_district_name_and_growth
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = ["WILEY RE-13 JT", 0.30000000000000004]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
  end


  def test_top_statewide_growth_returns_leader_for_eighth_grade
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = ["COTOPAXI RE-3", 0.1309999999999999]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading)
  end

  def test_top_statewide_growth_returns_leader_for_eighth_grade
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = [["COTOPAXI RE-3", 0.1309999999999999], ["OURAY R-1", 0.065], ["DOLORES COUNTY RE NO.2", 0.0625]]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 8, top: 3, subject: :reading)
    assert_equal 3, ha.top_statewide_test_year_over_year_growth(grade: 8, top: 3, subject: :reading).count
  end

  def test_search_for_top_growth_returns_a_sorted_array
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of Array, ha.search_top_growth_by_subj(grade: 8, subject: :reading)
    assert_equal ["COTOPAXI RE-3", 0.1309999999999999], ha.search_top_growth_by_subj(grade: 8, subject: :reading)[-1]
  end

  def test_find_growths_returns_array_of_unsorted_growth_data
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    data = {grade: 8, subject: :reading}
    statewide_test_data = ha.district_repo.statewide_repo.statewide_tests

    assert_instance_of Array, ha.find_growths(data, statewide_test_data, 1)
  end

  def test_find_minimun_year_returns_array_of_district_year_and_growth
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    data = {grade: 8, subject: :reading}
    district = ha.district_repo.find_by_name("academy 20").statewide_test
    expected = ["ACADEMY 20", 2008, 0.843]

    assert_equal expected, ha.find_minimum_year_data("ACADEMY 20", district, data)
  end

  def test_find_maximum_year_returns_array_of_district_year_and_growth
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    data = {grade: 8, subject: :reading}
    district = ha.district_repo.find_by_name("academy 20").statewide_test
    expected = ["ACADEMY 20", 2014, 0.827]

    assert_equal expected, ha.find_maximum_year_data("ACADEMY 20", district, data)
  end

  def test_search_for_top_growth_using_all_subjects
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = ["OURAY R-1", 0.10906500000000001]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 8)
  end

  def test_weight_does_not_need_to_be_added_defaults_to_1
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = ["COLORADO", 0.002145000000000002]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 3)
  end

  def test_weight_can_be_added_to_all_subject_growth_searches
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    expected = ["OURAY R-1", 0.1535]

    assert_equal expected, ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
  end

  def test_search_top_growth_all_subjects_returns_sorted_array
      dr = DistrictRepository.new
      dr.load_data({
                  :statewide_testing => {
                    :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
                  }})
      ha = HeadcountAnalyst.new(dr)
      result =  ha.search_for_top_growth_all_subjects(grade: 3)

      assert_instance_of Array, result
      assert result[0][-1] < result[-1][-1]
  end

  def test_find_all_subjects_growths_returns_array_with_result_for_3_subjects
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    input = {grade: 3}
    subjects = [:math, :reading, :writing]
    result = ha.find_all_subject_growths(input, subjects)
    district_count = result.select {|district| district[0] == "ACADEMY 20"}

    assert_equal 3,  district_count.count
  end

  def test_assign_weight_returns_a_float
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    input = {grade: 3, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0}, subject: :math}

    assert_instance_of Float, ha.assign_weight(input)
  end

  def test_assign_weight_defaults_weight_to_one_third
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    input = {grade: 3, subject: :math}

    assert_equal 0.33, ha.assign_weight(input)
  end

  def test_all_subjects_growths_returns_sorted_array_with_one_entry_per_district
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    input = [ ["ACADEMY 20", -0.0012650000000000011],
              ["ACADEMY 20", -0.0019250000000000018],
              ["ACADEMY 20", -0.0017600000000000018]]

    assert_instance_of Array, ha.organize_all_subjects_growths(input)
    assert_equal 1, ha.organize_all_subjects_growths(input).count
  end

  def test_compile_all_subjects_returns_average_as_a_float
    dr = DistrictRepository.new
    dr.load_data({
                :statewide_testing => {
                  :third_grade => "./test/fixtures/3rd grade students score proficient or above on the CSAP_TCAP short.csv"
                }})
    ha = HeadcountAnalyst.new(dr)
    input = [ ["ACADEMY 20", -0.0012650000000000011],
              ["ACADEMY 20", -0.0019250000000000018],
              ["ACADEMY 20", -0.0017600000000000018]]

    assert_instance_of Float, ha.compile_all_growths(input)
  end


















end
