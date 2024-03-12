describe 'POST /import' do
  context 'with valid CSV file' do
    it 'returns success response with valid CSV file' do
      allow(CSVImportWorker).to receive(:perform_async)
      file_path = File.expand_path('../../../csv/patients.csv', __dir__)
      csv_content = File.open(file_path)
  

      post '/import', 'csv-file' => Rack::Test::UploadedFile.new(csv_content, 'text/csv')

      expect(last_response.status).to eq(200)
    end
  
    it 'returns error response with invalid file format' do
      allow(CSVImportWorker).to receive(:perform_async)
      invalid_file_path = File.expand_path('../../../../data/data.txt', __dir__)
      csv_content = File.open(invalid_file_path)
  

      post '/import', 'csv-file' => Rack::Test::UploadedFile.new(csv_content, 'text/csv')
  
      expect(last_response.status).to eq(500)
      expect(last_response.body).to include('Error importing CSV file:')
    end
  end
end
