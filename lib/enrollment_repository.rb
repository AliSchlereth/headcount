require 'csv'
require_relative 'enrollment'

class EnrollmentRepository

  attr_reader :enrollments

  def initialize
    @enrollments = {}
  end

  def load_data(file_hash)
    file_hash[:enrollment].each do |symbol, file|
      data = CSV.open file, headers: true, header_converters: :symbol
      updated_symbol = symbol_translator(symbol)
      parse_for_enrollment_data(data, updated_symbol)
    end
  end

  def symbol_translator(symbol)
    case symbol
    when :kindergarten           then :kindergarten_participation
    when :high_school_graduation then :graduation_rates
    end
  end

  def parse_for_enrollment_data(data, symbol)
    data.each do |row|
      row[:data] = 0 if row[:data].match(/[a-zA-Z]+/)
      enrollments.has_key?(row[:location].upcase) ? add_to_enrollment_object(row, symbol) : create_enrollment_object(row, symbol)
    end
    enrollments
  end

  def create_enrollment_object(row, symbol)
    enrollment = Enrollment.new({:name => (row[:location]).upcase,
    symbol => {row[:timeframe].to_i => row[:data].to_f}})
    @enrollments[row[:location].upcase] = enrollment
  end

  def add_to_enrollment_object(row, symbol)
    attribute = symbol.to_s
    @enrollments[row[:location].upcase].send(attribute).merge!({row[:timeframe].to_i => row[:data].to_f})
  end

  def find_by_name(name)
    enrollments[name.upcase]
  end

end
