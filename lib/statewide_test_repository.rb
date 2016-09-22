require 'csv'
require_relative 'statewide_test'
require_relative 'loader'

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  # def load_data(file_hash)
  #   results = Loader.load_data(file_hash, :statewide_testing)
  #   parse_for_statewide_data(results[0], results[-1])
  # end

  def load_data(file_hash)
    file_hash[:statewide_testing].each do |symbol, file|
      data = Loader.load_data(file)
      parse_for_statewide_data(data, symbol)
    end
  end

  def parse_for_statewide_data(data, symbol)
    data.each do |row|
      row[:data] = 0 if row[:data].nil? || row[:data].match(/[a-zA-Z]+/)
      check_for_statewide_object(row, symbol)
    end
  end

  def check_for_statewide_object(row, symbol)
    if statewide_tests.has_key?(row[:location].upcase)
       add_to_statewide_object(row, symbol)
     else
        create_statewide_object(row, symbol)
      end
  end

  def create_statewide_object(row, symbol)
    create_obj_by_grade(row, symbol) if symbol == :third_grade ||
                                        symbol == :eighth_grade
    create_obj_by_subj(row, symbol)  if symbol == :math ||
                                        symbol == :reading ||
                                        symbol == :writing
  end

  def add_to_statewide_object(row, symbol)
    add_to_obj_by_grade(row, symbol) if symbol == :third_grade ||
                                        symbol == :eighth_grade
    add_to_obj_by_subj(row, symbol)  if symbol == :math ||
                                        symbol == :reading ||
                                        symbol ==  :writing
  end

  def create_obj_by_grade(row, symbol)
    subject = symbol_creator(row[:score])
    statewide_test = StatewideTest.new({:name => (row[:location]).upcase,
    symbol => {row[:timeframe].to_i => {subject => row[:data].to_f}}})
    @statewide_tests[row[:location].upcase] = statewide_test
  end

  def add_to_obj_by_grade(row, symbol)
    subject = symbol_creator(row[:score])
    statewide_obj = @statewide_tests[row[:location].upcase].send(symbol.to_s)
    if statewide_obj[row[:timeframe].to_i].nil?
      statewide_obj.merge!({row[:timeframe].to_i =>
        {subject => row[:data].to_f}})
    else
      statewide_obj[row[:timeframe].to_i].merge!({subject => row[:data].to_f})
    end
  end

  def create_obj_by_subj(row, symbol)
    ethnicity = symbol_creator(row[:race_ethnicity])
    statewide_test = StatewideTest.new({:name => (row[:location]).upcase,
    symbol => {ethnicity => {row[:timeframe].to_i => row[:data].to_f}}})
    @statewide_tests[row[:location].upcase] = statewide_test
  end

  def add_to_obj_by_subj(row, symbol)
    ethnicity = symbol_creator(row[:race_ethnicity])
    statewide_obj = @statewide_tests[row[:location].upcase].send(symbol.to_s)
    if statewide_obj[ethnicity].nil?
      statewide_obj.merge!({ethnicity =>
        {row[:timeframe].to_i => row[:data].to_f}})
    else
      statewide_obj[ethnicity].merge!({row[:timeframe].to_i => row[:data].to_f})
    end
  end

  def symbol_creator(string)
    case string
    when "All Students"              then :all_students
    when "Asian"                     then :asian
    when "Black"                     then :black
    when "Hawaiian/Pacific Islander" then :pacific_islander
    when "Hispanic"                  then :hispanic
    when "Native American"           then :native_american
    when "Two or more"               then :two_or_more
    when "White"                     then :white
    when "Math"                      then :math
    when "Reading"                   then :reading
    when "Writing"                   then :writing
    end
  end

  def find_by_name(name)
    statewide_tests[name.upcase]
  end

end
