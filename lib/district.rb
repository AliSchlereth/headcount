class District

  attr_accessor :name,
                :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(district_info)
    @name = district_info[:name]
    @enrollment = {}
    @statewide_test = {}
    @economic_profile = {}
  end

end
