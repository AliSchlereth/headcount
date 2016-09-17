require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test
  def test_can_create_statewide_object_for_third_grade
    row = {name: "DENVER", third_grade: {2016=>{"Math"=>0.502}}}
    statewide = StatewideTest.new(row)
    assert_equal "DENVER", statewide.name
    assert_equal ({2016=>{"Math"=>0.502}}), statewide.third_grade
  end

  def test_can_create_statewide_object_for_eighth_grade
    row = {name: "DENVER", eighth_grade: {2016=>{"Writing"=>0.512}}}
    statewide = StatewideTest.new(row)
    assert_equal "DENVER", statewide.name
    assert_equal ({2016=>{"Writing"=>0.512}}), statewide.eighth_grade
  end
end
