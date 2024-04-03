require 'csv'
require_relative 'database_connection'

module DataImporter
  TABLE_NAME = 'patients'.freeze
  ATTRIBUTES = %w[cpf name email birthday address city state medical_crm doctor_crm_state doctor_name
                      doctor_email result_token result_date test_type test_limits test_result].freeze
  
  def self.import_from_csv(file_path)
    conn = DatabaseConnection.connection
    prepared_statement = prepare_insert_statement(conn)

    conn.transaction do
      CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
        patient_data = [ATTRIBUTES, row.to_h.values].transpose.to_h
        conn.exec_prepared(prepared_statement, row.to_h.values)
      end
    end

    puts 'Dados importados com sucesso!'
  rescue PG::Error => e
    puts "Erro ao importar dados do CSV: #{e.message}"
  end

  def self.prepare_insert_statement(conn)
    insert_query = "INSERT INTO #{TABLE_NAME} (#{ATTRIBUTES.join(', ')}) VALUES (#{placeholders_list})"
    prepared_statement_exists = conn.exec_params("SELECT 1 FROM pg_prepared_statements WHERE name = 'insert_statement'").cmd_tuples == 1

    unless prepared_statement_exists
      conn.prepare('insert_statement', insert_query)
    end

    'insert_statement'
  end

  def self.placeholders_list
    ATTRIBUTES.map.with_index { |_attr, index| "$#{index + 1}" }.join(', ')
  end
end
