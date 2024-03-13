module CSVHelper
  def csv_file?(filename)
    File.extname(filename).downcase == '.csv'
  end
  
  def save_temp_file(file_content)
    ensure_tmp_directory_exists
    file_path = "tmp/#{SecureRandom.hex}.csv"
    File.open(file_path, 'wb') { |f| f.write(file_content.read) }
    file_path
  end

  private

  def ensure_tmp_directory_exists
    tmp_directory = 'tmp'
    Dir.mkdir(tmp_directory) unless Dir.exist?(tmp_directory)
  end
end
