require 'pg'
require_relative '../../import_from_csv'

describe 'table_exists?' do
  it 'retorna true se a tabela existir no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('t')
    allow(conn).to receive(:exec).and_return(query_result)

    expect(table_exists?(conn, 'table')).to eq(true)
  end

  it 'retorna false se a tabela não existir no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('f')
    allow(conn).to receive(:exec).and_return(query_result)

    expect(table_exists?(conn, 'other_table')).to eq(false)
  end
end

describe 'cpf_exists?' do
  it 'retorna true se o CPF for usado' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return(1)
    allow(conn).to receive(:exec_params).and_return(query_result)

    expect(cpf_exists?(conn, '987.654.321-98')).to eq(true)
  end

  it 'retorna false se o CPF ainda não for usado' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return(0)
    allow(conn).to receive(:exec_params).and_return(query_result)

    expect(cpf_exists?(conn, '987.654.321-98')).to eq(false)
  end
end

describe 'import_from_csv' do
  it 'insere dados do CSV no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:result_status).and_return(PG::PGRES_COMMAND_OK)
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('1') 
    allow(conn).to receive(:exec_params).and_return(query_result)

    allow(self).to receive(:table_exists?).and_return(true)
    allow(self).to receive(:insert_patient)

    expect { import_from_csv('spec/csv/patients.csv', conn) }.to output(/Dados importados com sucesso!/).to_stdout
  end

  it 'lida corretamente com erro ao importar dados do CSV' do
    conn = double('PG::Connection')
    allow(conn).to receive(:exec_params).and_raise(PG::Error, 'Erro ao importar dados do CSV')
    allow(self).to receive(:table_exists?).and_return(true)

    expect { import_from_csv('spec/csv/patients.csv', conn) }.to output(/Erro ao importar dados do CSV/).to_stdout
  end
end
