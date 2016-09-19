require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'

class DistrictRepository

  attr_reader :districts, :enrollment_repo, :statewide_repo

  def initialize
    @districts = {}
    @enrollment_repo = EnrollmentRepository.new
    @statewide_repo = StatewideTestRepository.new
  end

  def load_data(file_hash)
    load_enrollment_data(file_hash) if file_hash.key?(:enrollment)
    load_statewide_data(file_hash) if file_hash.key?(:statewide_testing)
  end

  def load_enrollment_data(file_hash)
    @enrollment_repo.load_data(file_hash)
    parse_enrollment_data
  end

  def parse_enrollment_data
    enrollment_repo.enrollments.each do |name, enrollment|
      @districts[name] = District.new(
          {:name => name}) unless districts.has_key?(name)
      @districts[name].enrollment = enrollment
    end
  end

  def load_statewide_data(file_hash)
    @statewide_repo.load_data(file_hash)
    parse_statewide_data
  end

  def parse_statewide_data
    statewide_repo.statewide_tests.each do |name, statewide|
      @districts[name] = District.new(
          {:name => name}) unless districts.has_key?(name)
      @districts[name].statewide_test = statewide
    end
  end

  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(sub_string)
    districts.select do |name, district|
      name.include?(sub_string.upcase)
    end.values
  end

end
