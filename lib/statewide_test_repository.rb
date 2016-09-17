require 'csv'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  def load_data(file_hash)
    file_hash[:statewide_testing].each do |symbol, file|
      data = CSV.open file, headers: true, header_converters: :symbol
      parse_for_statewide_data(data, symbol)
    end
  end

  def parse_for_statewide_data(data, symbol)
    data.each do |row|
      row[:data] = 0 if row[:data].nil? || row[:data].match(/[a-zA-Z]+/)
      statewide_tests.has_key?(row[:location].upcase) ? add_to_statewide_object(row, symbol) : create_statewide_object(row, symbol)
    end
    statewide_tests
  end

  def create_statewide_object(row, symbol)
    statewide_test = StatewideTest.new({:name => (row[:location]).upcase,
    symbol => {row[:timeframe].to_i => {row[:score] => row[:data].to_f}}})
    @statewide_tests[row[:location].upcase] = statewide_test
  end

  def add_to_statewide_object(row, symbol)
    attribute = symbol.to_s

    statewide_obj = @statewide_tests[row[:location].upcase].send(attribute)
    if statewide_obj[row[:timeframe].to_i].nil?
      statewide_obj.merge!({row[:timeframe].to_i=> {row[:score] => row[:data].to_f}})
    else
      statewide_obj[row[:timeframe].to_i].merge!({row[:score] => row[:data].to_f})
    end
  end

  def find_by_name(name)
    statewide_tests[name.upcase]
  end

end
