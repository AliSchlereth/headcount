require 'csv'
require_relative 'district'

class DistrictRepository

  attr_reader :district

  def initialize
    @district = {}
  end

  def load_data(file_hash)
    input_file = file_hash[:enrollment][:kindergarten]
    data = CSV.open input_file, headers: true, header_converters: :symbol
    parse_for_district(data)
  end

  def parse_for_district(data)
    data.each do |row|
      unless district.has_key?(row[:location].upcase)
        district = District.new({:name => (row[:location]).upcase})
        @district[row[:location].upcase] = district
      end
    end
    district
  end

  def find_by_name(name)
    district[name.upcase]
  end

  def find_all_matching(sub_string)
    district.select do |name, district|
      # matches << {key => value} if key.include?(sub_string.upcase)
      district if name.include?(sub_string.upcase)
    end.values
  end



end
