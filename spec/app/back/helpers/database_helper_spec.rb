describe 'table_exists?' do
  it 'retorna true se a tabela existir no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('t')
    allow(conn).to receive(:exec_params).and_return(query_result)

    expect(table_exists?(conn, 'table')).to eq(true)
  end

  it 'retorna false se a tabela não existir no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('f')
    allow(conn).to receive(:exec_params).and_return(query_result)

    expect(table_exists?(conn, 'other_table')).to eq(false)
  end
end

describe 'create_tables' do
  describe '#create_schema' do
    it 'cria o esquema "public" se ele não existir' do
      conn = double('PG::Connection')
      allow(conn).to receive(:exec).with("CREATE SCHEMA IF NOT EXISTS public;").and_return(nil)
      expect { create_schema(conn) }.not_to raise_error
      expect { create_schema(conn) }.to output(/Esquema 'public' criado com sucesso!/).to_stdout
    end

    it 'imprime uma mensagem de erro se a criação do esquema falhar' do
      conn = double('PG::Connection')
      allow(conn).to receive(:exec).with("CREATE SCHEMA IF NOT EXISTS public;").and_raise(PG::Error, "Erro ao criar o esquema 'public'")
      expect { create_schema(conn) }.to output(/Erro ao criar o esquema 'public'/).to_stdout
    end
  end

  describe '#create_table' do
    it 'cria a tabela de pacientes se ela não existir' do
      conn = double('PG::Connection')
      allow(conn).to receive(:exec).with(/CREATE TABLE IF NOT EXISTS public.patients/).and_return(nil)

      expect { create_table(conn) }.not_to raise_error
      expect { create_table(conn) }.to output(/Tabela 'patients' criada com sucesso!/).to_stdout
    end

    it 'imprime uma mensagem de erro se a criação da tabela falhar' do
      conn = double('PG::Connection')
      allow(conn).to receive(:exec).with(/CREATE TABLE IF NOT EXISTS public.patients/).and_raise(PG::Error, "Erro ao criar a tabela 'patients'")
      expect { create_table(conn) }.to output(/Erro ao criar a tabela 'patients'/).to_stdout
    end
  end
end

describe '#connect_to_database' do
  context 'when environment is :development' do
    it 'calls connect_to_development_database' do
      expect(self).to receive(:connect_to_development_database)
      connect_to_database(:development)
    end
  end

  context 'when environment is :test' do
    it 'calls connect_to_test_database' do
      expect(self).to receive(:connect_to_test_database)
      connect_to_database(:test)
    end
  end

  context 'when environment is not supported' do
    it 'raises ArgumentError' do
      expect { connect_to_database(:production) }.to raise_error(ArgumentError)
    end
  end
end
