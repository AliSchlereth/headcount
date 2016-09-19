require './test/test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  def test_economic_profile_can_store_all_correct_data_types
    row = {:median_household_income => "programming is fun",
           :children_in_poverty => "this one is sad",
           :free_or_reduced_price_lunch => "yay food",
           :title_i => "blahh",
            :name => "Morgan's School"}
    ep = EconomicProfile.new(row)

    assert_equal "programming is fun", ep.median_household_income
    assert_equal "this one is sad", ep.children_in_poverty
    assert_equal "yay food", ep.free_or_reduced_price_lunch
    assert_equal "blahh", ep.title_i
    assert_equal "Morgan's School", ep.name
  end

  def test_economic_profile_can_store_different_data
    row = {:median_household_income => "working is fun",
           :children_in_poverty => "this one is :(",
           :free_or_reduced_price_lunch => "mmm za",
           :title_i => "gahh",
            :name => "Ali's School"}
    ep = EconomicProfile.new(row)

    assert_equal "working is fun", ep.median_household_income
    assert_equal "this one is :(", ep.children_in_poverty
    assert_equal "mmm za", ep.free_or_reduced_price_lunch
    assert_equal "gahh", ep.title_i
    assert_equal "Ali's School", ep.name
  end

  def test_economic_profile_sets_info_to_empty_hash_if_nil
    row = {:median_household_income => "working is fun",
           :children_in_poverty => "this one is :(",
           :title_i => "gahh",
            :name => "Ali's School"}
    ep = EconomicProfile.new(row)

    assert_equal ({}), ep.free_or_reduced_price_lunch
  end

  def test_can_return_lunch_percentage_in_year
    row = {:name => "Alamo",
           :free_or_reduced_price_lunch =>
              {2014 => {:percentage => 0.023, :total => 100}}}
    ep = EconomicProfile.new(row)

    assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_returns_unknown_data_error_for_invalid_lunch_year_percentage
    row = {:name => "Alamo",
           :free_or_reduced_price_lunch =>
              {2014 => {:percentage => 0.023, :total => 100}}}
    ep = EconomicProfile.new(row)

    assert_raises (UnknownDataError) do
      ep.free_or_reduced_price_lunch_percentage_in_year(1911)
    end
  end

  def test_can_return_lunch_number_in_year
    row = {:name => "Alamo",
           :free_or_reduced_price_lunch =>
              {2014 => {:percentage => 0.023, :total => 100}}}
    ep = EconomicProfile.new(row)

    assert_equal 100, ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_returns_unknown_data_error_for_invalid_lunch_year_number
    row = {:name => "Alamo",
           :free_or_reduced_price_lunch =>
              {2014 => {:percentage => 0.023, :total => 100}}}
    ep = EconomicProfile.new(row)

    assert_raises (UnknownDataError) do
      ep.free_or_reduced_price_lunch_number_in_year(1911)
    end
  end

  def test_children_in_poverty_in_year
    row = {:name => "Spanish",
           :children_in_poverty => {2012 => 0.1845}}
    ep = EconomicProfile.new(row)

    assert_equal 0.184, ep.children_in_poverty_in_year(2012)
  end

  def test_children_in_poverty_in_year_raises_error_for_invalid_year
    row = {:name => "Spanish",
           :children_in_poverty => {2012 => 0.1845}}
    ep = EconomicProfile.new(row)

    assert_raises (UnknownDataError) do
      ep.children_in_poverty_in_year(1907)
    end
  end

  def test_median_household_income_in_year
    row = {:name => "Spanish",
          :median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000}}
    ep = EconomicProfile.new(row)

    assert_equal 55000, ep.median_household_income_in_year(2014)
  end

  def test_median_household_income_in_year_raises_error_for_invalid_year
    row = {:name => "Spanish",
          :median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000}}
    ep = EconomicProfile.new(row)

    assert_raises (UnknownDataError) do
      ep.title_i_in_year(1907)
    end
  end

  def test_median_household_income_average
    row = {:name => "Spanish",
          :median_household_income => {[2014, 2015] => 50000, [2013, 2014] => 60000}}
    ep = EconomicProfile.new(row)

    assert_equal 55000, ep.median_household_income_average
  end

  def test_title_i_in_year
    row = {:name => "Spanish",
          :title_i => {2015 => 0.543}}
    ep = EconomicProfile.new(row)

    assert_equal 0.543, ep.title_i_in_year(2015)
  end

  def test_title_i_in_year_raises_error_for_invalid_year
    row = {:name => "Spanish",
          :title_i => {2015 => 0.543}}
    ep = EconomicProfile.new(row)

    assert_raises (UnknownDataError) do
      ep.title_i_in_year(1903)
    end
  end



end
