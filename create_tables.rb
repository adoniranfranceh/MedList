require 'pg'

def create_schema
  conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')

  begin
    conn.exec("CREATE SCHEMA IF NOT EXISTS public;")
    puts "Esquema 'public' criado com sucesso!"
  rescue PG::Error => e
    puts "Erro ao criar o esquema 'public': #{e.message}"
  ensure
    conn.close if conn
  end
end

def create_table
  conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')

  begin
    conn.exec <<-SQL
      CREATE TABLE IF NOT EXISTS public.patients (
        id SERIAL PRIMARY KEY,
        cpf VARCHAR(14) NOT NULL,
        nome VARCHAR(255) NOT NULL,
        email VARCHAR(255),
        data_nascimento DATE NOT NULL,
        endereco VARCHAR(255),
        cidade VARCHAR(100),
        estado VARCHAR(2),
        crm_medico VARCHAR(20)
      );
    SQL
    puts "Tabela 'patients' criada com sucesso!"
  rescue PG::Error => e
    puts "Erro ao executar a operação no banco de dados: #{e.message}"
  ensure
    conn.close if conn
  end
end

create_schema
create_table
