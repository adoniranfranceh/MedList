describe DataImporter do
  context '.import_from_csv' do
    it 'insere dados do CSV no banco de dados' do
      file_path = File.expand_path('../../../csv/patients.csv', __dir__)
  
      expect { DataImporter.import_from_csv(file_path) }.to output(/Dados importados com sucesso!/).to_stdout
    end
  
    it 'lida corretamente com erro ao importar dados do CSV' do
      allow(DatabaseConnection).to receive(:connection).and_raise(PG::Error, 'Erro ao importar dados do CSV')
  
      expect { DataImporter.import_from_csv('data/data.csv') }.to output(/Erro ao importar dados do CSV/).to_stdout
    end
  end

  context '.placeholders_list' do
    it 'retorna uma lista de espaços reservados com base no mapeamento' do
      placeholders = DataImporter.placeholders_list
      expect(placeholders).to eq('$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16')
    end
  end
end
