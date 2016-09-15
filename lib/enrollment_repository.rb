require 'csv'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(file_hash)
    # decide which overall type of data we need to parse for
    input_file = file_hash[:enrollment][:kindergarten]
    data = CSV.open input_file, headers: true, header_converters: :symbol
    parse_for_enrollment_data(data, input_file)
  end

  def parse_for_enrollment_data(data, input_hash)
    data_types = input_hash[:enrollment].values
    data_types.each do |data|
      parse_for_kindergarten_data if data == :kindergarten
      parse_for_high_school_data  if data == :high_school_graduation
    end
  end

  def parse_for_kindergarten_data(data)
    data.each do |row|
      row[:data] = 0 if row[:data].match(/[a-zA-Z]+/)
      enrollments.has_key?(row[:location].upcase) ? add_to_kindergarten_participation(row) : create_enrollment_object_for_kindergarten(row)
    end
    enrollments
  end

  def create_enrollment_object_for_kindergarten(row)
    enrollment = Enrollment.new({:name => (row[:location]).upcase,
    :kindergarten_participation => {row[:timeframe].to_i => row[:data].to_f},
    # :high_school_graduation => {row[:timeframe].to_i => row[:data].to_f }})
    @enrollments[row[:location].upcase] = enrollment
  end

  def add_to_kindergarten_participation(row)
    @enrollments[row[:location].upcase].kindergarten_participation.merge!({row[:timeframe].to_i => row[:data].to_f})
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end

end
