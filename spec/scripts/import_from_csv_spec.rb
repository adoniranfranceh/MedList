require 'pg'
require_relative '../../app/back/import_from_csv'

describe 'import_from_csv' do
  it 'insere dados do CSV no banco de dados' do
    conn = double('PG::Connection')
    query_result = instance_double('PG::Result')
    allow(query_result).to receive(:result_status).and_return(PG::PGRES_COMMAND_OK)
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('1') 
    allow(conn).to receive(:exec_params).and_return(query_result)

    allow(self).to receive(:table_exists?).and_return(true)

    expect { import_from_csv('spec/csv/patients.csv', conn) }.to output(/Dados importados com sucesso!/).to_stdout
  end

  it 'lida corretamente com erro ao importar dados do CSV' do
    conn = double('PG::Connection')
    allow(conn).to receive(:exec_params).and_raise(PG::Error, 'Erro ao importar dados do CSV')
    allow(self).to receive(:table_exists?).and_return(true)

    expect { import_from_csv('spec/csv/patients.csv', conn) }.to output(/Erro ao importar dados do CSV/).to_stdout
  end
end

describe 'insert_patient' do
  it 'insere dados do paciente no banco de dados e retorna os dados inseridos' do
    conn = double('PG::Connection')
    file_path = File.expand_path('../json/patients.json', __dir__)
    json_data = JSON.parse(File.read(file_path))

    allow(conn).to receive(:exec_params).and_return(json_data[0])

    inserted_data = insert_patient(conn, json_data[0])
    expect(inserted_data).to eq(json_data[0])
  end
end
