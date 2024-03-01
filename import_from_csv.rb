require 'pg'
require 'csv'

def table_exists?(conn, table_name)
  result = conn.exec("SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '#{table_name}');")
  result.dig(0, 'exists') == 't'
end

def create_table(conn)
  load 'create_tables.rb'
end

def import_from_csv(file_path)
  conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')

  begin
    unless table_exists?(conn, 'patients')
      create_table(conn)
    end

    CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
      next if cpf_exists?(conn, row['cpf'])
      puts row['cpf']
      puts row.class
      conn.exec_params('INSERT INTO patients (cpf, nome, email, data_nascimento, endereco, cidade, estado, crm_medico) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)', [row['cpf'], row['nome paciente'], row['email paciente'], row['data nascimento paciente'], row['endereço/rua paciente'], row['cidade paciente'], row['estado paciente'], row['crm médico']])

    end
    puts "Dados importados com sucesso!"
  rescue PG::Error => e
    puts "Erro ao executar a operação no banco de dados: #{e.message}"
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
;paciente;;cidade paciente;estado patiente;crm médico;crm médico estado