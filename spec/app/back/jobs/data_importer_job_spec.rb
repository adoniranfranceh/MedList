RSpec.describe CSVImportWorker do
  context '.perform_async' do
    it 'importa conteúdo CSV com sucesso' do
      allow(DataImporter).to receive(:import_from_csv)

      allow($stdout).to receive(:puts)
      file_path = File.expand_path('../../../csv/patients.csv', __dir__)

      allow(File).to receive(:delete).with(file_path).and_return(nil)

      subject.perform(file_path)

      expect(DataImporter).to have_received(:import_from_csv).with(file_path)

      expect($stdout).to have_received(:puts).with('Arquivo temporário excluído com sucesso!')

      expect($stdout).not_to have_received(:puts).with(/^Erro ao processar o arquivo CSV:/)
    end

    it 'importa conteúdo CSV e dá erro' do
      allow(DataImporter).to receive(:import_from_csv).and_raise(StandardError, 'Error message')

      allow($stdout).to receive(:puts)
      file_path = File.expand_path('../../../csv/patients.csv', __dir__)

      subject.perform(file_path)

      expect($stdout).to have_received(:puts).with('Erro ao processar o arquivo CSV: Error message')
    end
  end
end
