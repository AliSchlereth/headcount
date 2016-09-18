require './test/test_helper'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test
  def test_initializes_with_empty_economic_profiles_hash
    epr = EconomicProfileRepository.new

    assert_equal ({}), epr.economic_profiles
  end

  def test_can_load_children_in_poverty_income_data_and_title_i
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :title_i => "./data/Title I students.csv"}})

    assert_instance_of EconomicProfile, epr.economic_profiles.values[0]
  end

  def test_can_find_economic_profile_object_by_name
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :title_i => "./data/Title I students.csv"}})
    ep = epr.find_by_name("Academy 20")

    assert_equal "ACADEMY 20", ep.name
  end

  def test_economic_proifle_contains_correct_data_for_poverty
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :children_in_poverty => "./data/School-aged children in poverty.csv"}})
    ep = epr.find_by_name("Academy 20")

    assert_equal 0.04404, ep.children_in_poverty[2008]
  end

  def test_economic_proifle_contains_correct_data_for_title_i
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :title_i => "./data/Title I students.csv"}})
    ep = epr.find_by_name("Academy 20")

    assert_equal 0.01072, ep.title_i[2012]
  end

  def test_can_load_median_household_income_data
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv"}})

    assert_instance_of EconomicProfile, epr.economic_profiles.values[0]
  end

  def test_contains_correct_data_for_median_household_income
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv"}})
    ep = epr.find_by_name("academY 20")

    assert_equal 85060, ep.median_household_income[[2005,2009]]
  end

  def test_can_load_lunch_data
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    assert_instance_of EconomicProfile, epr.economic_profiles.values[0]
  end

  def test_contains_correct_data_for_free_or_reduced_lunch
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    ep = epr.find_by_name("academY 20")
    expected = {:total=>905, :percentage=>0.0484}

    assert_equal (expected), ep.free_or_reduced_price_lunch[2002]
  end

  def test_can_return_lunch_percentage_by_year_for_economic_profile_obj
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    ep = epr.find_by_name("academY 20")

    assert_equal 0.048, ep.free_or_reduced_price_lunch_percentage_in_year(2002)
  end

  def test_returns_unknown_data_error_for_invalid_lunch_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    ep = epr.find_by_name("academY 20")

    assert_raises (UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(1911)
    end
  end

  def test_can_return_lunch_number_by_year_for_economic_profile_obj
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    ep = epr.find_by_name("academY 20")

    assert_equal 905, ep.free_or_reduced_price_lunch_number_in_year(2002)
  end

  def test_returns_unknown_data_error_for_invalid_lunch_year
    epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"}})
    ep = epr.find_by_name("academY 20")

    assert_raises (UnknownDataError) do
      ep.free_or_reduced_price_lunch_number_in_year(1911)
    end
  end





end
