require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository

  attr_reader :districts, :enrollment_repo

  def initialize
    @districts = {}
    @enrollment_repo = EnrollmentRepository.new
  end

  def load_data(file_hash)
    @enrollment_repo.load_data(file_hash) if file_hash.key?(:enrollment)
    parse_data
  end

  def parse_data
    enrollment_repo.enrollments.each do |key, enrollment|
      unless districts.has_key?(enrollment.name)
        district = District.new({:name => enrollment.name,
          :enrollment => enrollment})
        @districts[enrollment.name] = district
      end
    end
    districts
  end

  def find_by_name(name)
    districts[name.upcase]
  end

  def find_all_matching(sub_string)
    districts.select do |name, district|
      district if name.include?(sub_string.upcase)
    end.values
  end



end
