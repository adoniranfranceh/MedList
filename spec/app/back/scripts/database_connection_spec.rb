describe DatabaseConnection do
  context '.connection' do
    it 'retorna um objeto PG::Connection' do
      connection = described_class.connection
      expect(connection).to be_an_instance_of(PG::Connection)
      connection.close if connection
    end

    it 'conecta para o BD de desenvolvimento' do
      connection = described_class.connection
      expect(connection.db).to eq('postgres')
      connection.close if connection
    end
  end
end
