module HeadcountCalculator

  def self.truncate(float)
    (float*1000).floor/1000.0
  end

  def self.truncate_data(data)
    data.each do |year, percentages|
      truncate(percentages[:math]) unless percentages[:math].nil?
      truncate(percentages[:reading]) unless percentages[:reading].nil?
      truncate(percentages[:writing]) unless percentages[:writing].nil?
    end
  end

end
