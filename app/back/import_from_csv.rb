require 'pg'
require 'csv'
require_relative 'create_tables'

TABLE_NAME = 'patients'.freeze

def table_exists?(conn, table_name)
  result = conn.exec("SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '#{table_name}');")
  result.getvalue(0, 0) == 't'
end

def import_from_csv(file_path, conn)
  create_table(conn) unless table_exists?(conn, TABLE_NAME)

  begin
    CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
      next if cpf_exists?(conn, row['cpf'])
      insert_patient(conn, row)
    end
    puts "Dados importados com sucesso!"
  rescue PG::Error => e
    puts "Erro ao importar dados do CSV: #{e.message}"
  end
end

def cpf_exists?(conn, cpf)
  result = conn.exec_params('SELECT COUNT(*) FROM patients WHERE cpf = $1', [cpf])
  count = result.getvalue(0, 0).to_i
  count > 0
end

def insert_patient(conn, data)
  conn.exec_params(
    'INSERT INTO patients (cpf, name, email, birthday, address, city, state, medical_crm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)',
    [
      data['cpf'],
      data['nome paciente'],
      data['email paciente'],
      data['data nascimento paciente'],
      data['endereço/rua paciente'],
      data['cidade paciente'],
      data['estado patiente'],
      data['crm médico']
    ]
  )
end

conn = PG.connect(DB_PARAMS)
import_from_csv('data/data.csv', conn)
