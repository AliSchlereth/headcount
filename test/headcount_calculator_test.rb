require './test/test_helper'
require './lib/headcount_calculator'

class HeadcountCalculatorTest < Minitest::Test
  def test_it_truncates_a_float
    input = 6666/10000.0
    assert_equal 0.666, HeadcountCalculator.truncate(input)
  end
end
