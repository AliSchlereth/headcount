require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_can_create_statewide_object_for_third_grade
    row = {name: "DENVER", third_grade: {2016=>{:math=>0.502}}}
    statewide = StatewideTest.new(row)
    assert_equal "DENVER", statewide.name
    assert_equal ({2016=>{:math=>0.502}}), statewide.third_grade
  end

  def test_can_create_statewide_object_for_eighth_grade
    row = {name: "DENVER", eighth_grade: {2016=>{:writing=>0.512}}}
    statewide = StatewideTest.new(row)
    assert_equal "DENVER", statewide.name
    assert_equal ({2016=>{:writing=>0.512}}), statewide.eighth_grade
  end

  def test_can_create_statewide_object_for_math
    row = {name: "DENVER", math: {:asian => {2016=>0.512}}}
    statewide = StatewideTest.new(row)

    assert_equal "DENVER", statewide.name
    assert_equal ({:asian => {2016=>0.512}}), statewide.math
  end

  def test_can_create_statewide_object_for_math
    row = {name: "DENVER", reading: {:asian => {2016=>0.512}}}
    statewide = StatewideTest.new(row)

    assert_equal "DENVER", statewide.name
    assert_equal ({:asian => {2016=>0.512}}), statewide.reading
  end

  def test_can_create_statewide_object_for_math
    row = {name: "DENVER", writing: {:asian => {2016=>0.512}}}
    statewide = StatewideTest.new(row)

    assert_equal "DENVER", statewide.name
    assert_equal ({:asian => {2016=>0.512}}), statewide.writing
  end

  def test_proficient_by_grade_third
    row = {name: "DENVER", third_grade: {2016=>{:math=>0.502}}}
    statewide = StatewideTest.new(row)

    assert_equal ({2016=>{:math=>0.502}}), statewide.proficient_by_grade(3)
  end

  def test_proficient_by_grade_eight
    row = {name: "DENVER", eighth_grade: {2016=>{:math=>0.502}}}
    statewide = StatewideTest.new(row)

    assert_equal ({2016=>{:math=>0.502}}), statewide.proficient_by_grade(8)
  end

  def test_proficient_by_grade_wrong_grade
    row = {name: "DENVER", third_grade: {2016=>{:math=>0.502}}}
    statewide = StatewideTest.new(row)

    assert_raises (UnknownDataError) do
      statewide.proficient_by_grade(9)
    end
  end

  # def test_proficient_for_asian_students
  #   row = {name: "DENVER", math: {:asian => {2016=>0.512}},
  #     reading: {:asian => {2016=>0.5452}},
  #     writing: {:asian => {2016=>0.333}}}
  #   statewide = StatewideTest.new(row)
  #
  #   assert_equal ({2016=>0.512}), statewide.proficient_by_race_or_ethnicity(:asian)
  # end




end
