require 'pg'
require_relative '../../app/back/main'
require_relative '../../app/back/data_importer'

include DataImporter

describe 'import_from_csv' do
  it 'insere dados do CSV no banco de dados' do
    expect { DataImporter.import_from_csv('data/data.csv') }.to output(/Dados importados com sucesso!/).to_stdout
  end

  it 'lida corretamente com erro ao importar dados do CSV' do
    allow(DatabaseConnection).to receive(:connection).and_raise(PG::Error, 'Erro ao importar dados do CSV')

    expect { DataImporter.import_from_csv('data/data.csv') }.to output(/Erro ao importar dados do CSV/).to_stdout
  end
end
