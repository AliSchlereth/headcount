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
end
