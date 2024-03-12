describe 'import_from_csv' do
  it 'insere dados do CSV no banco de dados' do
    file_path = File.expand_path('../../../csv/patients.csv', __dir__)

    expect { DataImporter.import_from_csv(file_path) }.to output(/Dados importados com sucesso!/).to_stdout
  end

  it 'lida corretamente com erro ao importar dados do CSV' do
    allow(DatabaseConnection).to receive(:connection).and_raise(PG::Error, 'Erro ao importar dados do CSV')

    expect { DataImporter.import_from_csv('data/data.csv') }.to output(/Erro ao importar dados do CSV/).to_stdout
  end
end
