require_relative '../../create_tables'

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
