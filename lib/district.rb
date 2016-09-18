class District

  attr_accessor :name, :enrollment, :statewide_test

  def initialize(district_info)
    @name = district_info[:name]
    @enrollment = district_info[:enrollment]
    @statewide_test = district_info[:statewide_testing]
  end

end
