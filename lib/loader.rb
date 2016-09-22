class Loader

  def self.load_data(file)
    CSV.open file, headers: true, header_converters: :symbol
  end

#   method that is called from DR
#     decides which respository to send it to
#
#   method that is called from ER
#     does all the enrollment respository loading functions
#
#   method that is called from STR
#    does all the statewide testing repository loading functions
#
#   method that is called from EPR
#     take in
#    does all the statewide testing repository loading functions
end
