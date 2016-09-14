class District

  attr_reader :name, :enrollment

  def initialize(district_info)
    @name = district_info[:name]
    @enrollment = district_info[:enrollment]
  end

end
