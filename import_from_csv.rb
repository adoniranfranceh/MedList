require 'pg'
require 'csv'

DB_PARAMS = {
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres',
  host: 'db'
}.freeze

TABLE_NAME = 'patients'.freeze

def table_exists?(conn, table_name)
  result = conn.exec("SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '#{table_name}');")
  result.getvalue(0, 0) == 't'
end

def create_table(conn)
  load 'create_tables.rb'
end

def import_from_csv(file_path)
  conn = PG.connect(DB_PARAMS)

  begin
    create_table(conn) unless table_exists?(conn, TABLE_NAME)

    CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
      next if cpf_exists?(conn, row['cpf'])

      conn.exec_params('INSERT INTO patients (cpf, name, email, birthday, address, city, state, medical_crm) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)', [
        row['cpf'],
        row['nome paciente'],
        row['email paciente'],
        row['data nascimento paciente'],
        row['endereço/rua paciente'],
        row['cidade paciente'],
        row['estado paciente'],
        row['crm médico']
      ])
    end
    puts "Dados importados com sucesso!"
  rescue PG::Error => e
  ensure
    conn.close if conn
  end
end

def cpf_exists?(conn, cpf)
  result = conn.exec_params('SELECT COUNT(*) FROM patients WHERE cpf = $1', [cpf])
  count = result.getvalue(0, 0).to_i
  count > 0
end

import_from_csv('data/data.csv')
