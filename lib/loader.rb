class Loader

  def self.load_data(file)
    CSV.open file, headers: true, header_converters: :symbol
  end

end
