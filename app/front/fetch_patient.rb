require 'faraday'
require 'faraday/multipart'

class FetchPatient
  def self.all
    response = Faraday.get('http://app_back:4567/tests')
    response.body
  end

  def self.search_per_token(token)
    response = Faraday.get("http://app_back:4567/tests/#{token}")
    response.body
  end

  def self.search_per_name(name)
    response = Faraday.get("http://app_back:4567/tests?search=#{name}")
    response.body
  end

  def self.import(csv_file)
    conn = Faraday.new(url: 'http://app_back:4567') do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end

    params = { 'csv-file': Faraday::UploadIO.new(csv_file, 'text/csv') }

    response = conn.post('/import', params)

    response.body
  end
end
