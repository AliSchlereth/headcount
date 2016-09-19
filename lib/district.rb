class District

  attr_accessor :name,
                :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(district_info)
    @name = district_info[:name]
    @enrollment = district_info[:enrollment]
    @statewide_test = district_info[:statewide_testing]
    @economic_profile = district_info[:economic_profile]
  end

end
