require './test/test_helper'
require './lib/headcount_calculator'

class HeadcountCalculatorTest < Minitest::Test

  def test_it_truncates_a_float
    input = 6666/10000.0
    assert_equal 0.666, HeadcountCalculator.truncate(input)
  end

  def test_can_truncate_sets_of_data
    data = {2016 => {:math=>0.8186, :reading=>0.8937, :writing=>0.8083}}
    expected = {2016=>{:math=>0.818, :reading=>0.893, :writing=>0.808}}

    assert_equal (expected), HeadcountCalculator.truncate_data(data)
  end

end
