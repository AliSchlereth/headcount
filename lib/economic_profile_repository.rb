require 'csv'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :economic_profiles

  def initialize
    @economic_profiles = {}
  end

  def load_data(file_hash)
    file_hash[:economic_profile].each do |symbol, file|
      data = CSV.open file, headers: true, header_converters: :symbol
      parse_for_economic_data(data, symbol)
    end
  end

  def parse_for_economic_data(data, symbol)
    data.each do |row|
      next if row[:dataformat] == "Number" && symbol == :children_in_poverty
      row[:data] = 0 if row[:data].nil? || row[:data].match(/[a-zA-Z]+/)
      check_for_economic_object(row, symbol)
    end
    economic_profiles
  end

  def check_for_economic_object(row, symbol)
    if economic_profiles.has_key?(row[:location].upcase)
       add_to_economic_object(row, symbol)
     else
        create_economic_object(row, symbol)
      end
  end

  def create_economic_object(row, symbol)
    create_obj_by_income(row, symbol)  if symbol == :median_household_income
    create_obj_by_poverty(row, symbol) if symbol == :children_in_poverty ||
                                          symbol == :title_i
    create_obj_by_lunch(row, symbol)   if symbol == :free_or_reduced_price_lunch
  end

  def add_to_economic_object(row, symbol)
    add_to_obj_by_income(row, symbol)  if symbol == :median_household_income
    add_to_obj_by_poverty(row, symbol) if symbol == :children_in_poverty ||
                                          symbol == :title_i
    add_to_obj_by_lunch(row, symbol)   if symbol == :free_or_reduced_price_lunch
  end

  def create_obj_by_poverty(row, symbol)
    economic_profile = EconomicProfile.new({:name => (row[:location]).upcase,
      symbol => {row[:timeframe].to_i => row[:data].to_f}})
    @economic_profiles[row[:location].upcase] = economic_profile
  end

  def add_to_obj_by_poverty(row, symbol)
    attribute = symbol.to_s
    economic_obj = @economic_profiles[row[:location].upcase].send(attribute)
    economic_obj[row[:timeframe].to_i] = row[:data].to_f
  end

  def find_by_name(name)
    economic_profiles[name.upcase]
  end

end
