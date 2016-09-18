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

end
