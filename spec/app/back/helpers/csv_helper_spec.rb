describe CSVHelper do
  context '#csv_file?' do
    it 'retorna true se o arquivo tiver extensão .csv' do
      expect(csv_file?('data.csv')).to be_truthy
    end

    it 'retorna false se o arquivo não tiver extensão .csv' do
      expect(csv_file?('data.txt')).to be_falsey
    end
  end

  context '#save_temp_file' do
    let(:file_content) { "Nome,Idade\nJoão,30\nMaria,25\n" }
    let(:temp_file_path) { save_temp_file(file_content) }

    it 'salva o conteúdo do arquivo temporário' do
      expect(File.exist?(temp_file_path)).to be_truthy
    end

    it 'salva o conteúdo do arquivo corretamente' do
      saved_content = File.read(temp_file_path)
      expect(saved_content).to eq(file_content)
    end

    it 'retorna o caminho do arquivo temporário' do
      expect(temp_file_path).to start_with('tmp/')
      expect(temp_file_path).to end_with('.csv')
    end
  end

  context '#ensure_tmp_directory_exists' do
    it 'cria o diretório tmp se ele não existir' do
      allow(Dir).to receive(:exist?).with('tmp').and_return(false)
      expect(Dir).to receive(:mkdir).with('tmp')

      CSVHelper.send(:ensure_tmp_directory_exists)
    end

    it 'não cria o diretório tmp se ele já existir' do
      allow(Dir).to receive(:exist?).with('tmp').and_return(true)
      expect(Dir).not_to receive(:mkdir)

      CSVHelper.send(:ensure_tmp_directory_exists)
    end
  end
end
