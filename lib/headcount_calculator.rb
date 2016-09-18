module HeadcountCalculator

  def self.truncate(float)
    (float*1000).floor/1000.0
  end

  def self.truncate_data(data)
    data.each do |year, num|
      num[:math] = truncate(num[:math]) unless num[:math].nil?
      num[:reading] = truncate(num[:reading]) unless num[:reading].nil?
      num[:writing] = truncate(num[:writing]) unless num[:writing].nil?
    end
  end

end
