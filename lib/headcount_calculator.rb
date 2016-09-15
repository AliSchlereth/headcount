module HeadcountCalculator
  def self.truncate(float)
    (float*1000).floor/1000.0
  end
end
