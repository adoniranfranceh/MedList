require_relative '../../create_tables'

describe 'create_tables' do
  describe '#create_schema' do
    it 'cria o esquema "public" se ele não existir' do
      expect { create_schema }.not_to raise_error
      expect { create_schema }.to output(/Esquema 'public' criado com sucesso!/).to_stdout
    end

    it 'imprime uma mensagem de erro se a criação do esquema falhar' do
      allow_any_instance_of(PG::Connection).to receive(:exec).and_raise(PG::Error, "Erro ao criar o esquema 'public'")
      expect { create_schema }.to output(/Erro ao criar o esquema 'public'/).to_stdout
    end
  end

  describe '#create_table' do
    it 'cria a tabela de pacientes se ela não existir' do
      expect { create_table }.not_to raise_error
      expect { create_table }.to output(/Tabela 'patients' criada com sucesso!/).to_stdout
    end

    it 'imprime uma mensagem de erro se a criação da tabela falhar' do
      allow_any_instance_of(PG::Connection).to receive(:exec).and_raise(PG::Error, "Erro ao criar a tabela 'patients'")
      expect { create_table }.to output(/Erro ao criar a tabela 'patients'/).to_stdout
    end
  end
end
