require 'csv'
require_relative 'database_connection'

module DataImporter
  TABLE_NAME = 'patients'.freeze
  FIELDS_MAPPING = {
    'cpf' => 'cpf',
    'nome paciente' => 'name',
    'email paciente' => 'email',
    'data nascimento paciente' => 'birthday',
    'endereço/rua paciente' => 'address',
    'cidade paciente' => 'city',
    'estado patiente' => 'state',
    'crm médico' => 'medical_crm',
    'crm médico estado' => 'doctor_crm_state',
    'nome médico' => 'doctor_name',
    'email médico' => 'doctor_email',
    'token resultado exame' => 'result_token',
    'data exame' => 'result_date',
    'tipo exame' => 'test_type',
    'limites tipo exame' => 'test_limits',
    'resultado tipo exame' => 'test_result'
  }.freeze

  def self.import_from_csv(file_path)
    conn = DatabaseConnection.connection
    prepared_statement = prepare_insert_statement(conn)

    conn.transaction do
      CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
        patient_data = transform_row(row.to_h)
        conn.exec_prepared(prepared_statement, patient_data.values)
      end
    end

    puts 'Dados importados com sucesso!'
  rescue PG::Error => e
    puts "Erro ao importar dados do CSV: #{e.message}"
  end

  def self.prepare_insert_statement(conn)
    insert_query = "INSERT INTO #{TABLE_NAME} (#{FIELDS_MAPPING.values.join(', ')}) VALUES (#{placeholders_list})"
    prepared_statement_exists = conn.exec_params("SELECT 1 FROM pg_prepared_statements WHERE name = 'insert_statement'").cmd_tuples == 1

    unless prepared_statement_exists
      conn.prepare('insert_statement', insert_query)
    end

    'insert_statement'
  end

  def self.transform_row(row)
    row.transform_keys { |key| FIELDS_MAPPING[key] }
  end

  def self.placeholders_list
    (1..FIELDS_MAPPING.size).map { |i| "$#{i}" }.join(', ')
  end
end
