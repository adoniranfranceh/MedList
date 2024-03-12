require 'sidekiq'
require_relative '../data_importer'

class CSVImportWorker
  include Sidekiq::Worker
  include DataImporter

  def perform(csv_content)
    DataImporter.import_from_csv(csv_content)

    File.delete(csv_content)

    puts 'Arquivo temporário excluído com sucesso!'
  rescue StandardError => e
    puts "Erro ao processar o arquivo CSV: #{e.message}"
  end
end
