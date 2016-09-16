class District

  attr_reader :name, :enrollment, :statewide

  def initialize(district_info)
    @name = district_info[:name]
    @enrollment = district_info[:enrollment]
    @statewide_test = district_info[:statewide_testing]
  end

end
