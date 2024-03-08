require 'pg'

DB_PARAMS = {
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres',
  host: 'db'
}.freeze

def create_schema(conn)
  begin
    conn.exec("CREATE SCHEMA IF NOT EXISTS public;")
    puts "Esquema 'public' criado com sucesso!"
  rescue PG::Error => e
    puts "Erro ao criar o esquema 'public': #{e.message}"
  end
end

def create_table(conn)
  begin
    conn.exec <<-SQL
      CREATE TABLE IF NOT EXISTS public.patients (
        id SERIAL PRIMARY KEY,
        cpf VARCHAR(14) NOT NULL,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255),
        birthday DATE NOT NULL,
        address VARCHAR(255),
        city VARCHAR(100),
        state VARCHAR(20),
        medical_crm VARCHAR(20),
        doctor_crm_state VARCHAR(20),
        doctor_name VARCHAR(255),
        doctor_email VARCHAR(255),
        result_token VARCHAR(255),
        result_date DATE,
        test_type VARCHAR(255),
        test_limits VARCHAR(255),
        test_result VARCHAR(255)
      );
    SQL
    puts "Tabela 'patients' criada com sucesso!"
  rescue PG::Error => e
    puts "Erro ao executar a operação no banco de dados: #{e.message}"
  end
end

def schema_exists?(conn, schema_name)
  result = conn.exec("SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = '#{schema_name}');")
  result.getvalue(0, 0) == 't'
end

conn = PG.connect(DB_PARAMS)
create_schema(conn) unless schema_exists?(conn, 'public')
create_table(conn)
conn.close
