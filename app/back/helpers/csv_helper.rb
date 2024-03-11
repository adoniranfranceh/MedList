module CSVHelper
  def csv_file?(filename)
    File.extname(filename).downcase == '.csv'
  end
  
  def save_temp_file(file)
    file_path = "tmp/#{SecureRandom.hex}.csv"
    File.open(file_path, 'wb') { |f| f.write(file.read) }
    file_path
  end
end
