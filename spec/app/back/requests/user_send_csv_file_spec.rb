describe 'POST /import' do
  it 'retorna success response com arquivo CSV válid' do
    allow(CSVImportWorker).to receive(:perform_async)
    file_path = File.expand_path('../../../csv/patients.csv', __dir__)
    csv_content = File.open(file_path)


    post '/import', 'csv-file' => Rack::Test::UploadedFile.new(csv_content, 'text/csv')

    expect(last_response.status).to eq(200)
  end

  it 'retorna success response com arquivo formato inválido' do
    allow(CSVImportWorker).to receive(:perform_async)
    invalid_file_path = File.expand_path('../../../../data/data.txt', __dir__)
    csv_content = File.open(invalid_file_path)


    post '/import', 'csv-file' => Rack::Test::UploadedFile.new(csv_content, 'text/csv')

    expect(last_response.status).to eq(500)
    expect(last_response.body).to include('Invalid file format. Only CSV files are allowed.')
  end
end
