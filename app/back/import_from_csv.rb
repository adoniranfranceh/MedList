require 'pg'
require 'csv'
require_relative 'create_tables'
require_relative 'helpers/database_helper'

TABLE_NAME = 'patients'.freeze

class DatabaseConnection
  extend DatabaseHelper
  def self.connection
    connect_to_database(ENV['RACK_ENV'].to_sym)
  end
end

class PatientDB
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

  TABLE_NAME = 'patients'.freeze

  def initialize(data)
    @data = data.transform_keys { |key| FIELDS_MAPPING[key] }
  end

  def insert_into_database
    conn = DatabaseConnection.connection
    insert_query = "INSERT INTO #{TABLE_NAME} (#{fields}) VALUES (#{placeholders})"
    conn.exec_params(insert_query, values)
  end

  private

  def fields
    @data.keys.join(', ')
  end

  def placeholders
    (1..@data.size).map { |i| "$#{i}" }.join(', ')
  end

  def values
    @data.values
  end
end

def import_from_csv(file_path)
  conn = DatabaseConnection.connection
  patients = []

  CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
    patient_data = row.to_h
    patients << PatientDB.new(patient_data)
  end

  conn.transaction do
    patients.each(&:insert_into_database)
  end

  puts "Dados importados com sucesso!"
rescue PG::Error => e
  puts "Erro ao importar dados do CSV: #{e.message}"
end

start_time = Time.now
import_from_csv('data/data.csv')
end_time = Time.now

puts end_time - start_time 
