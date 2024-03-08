require 'pg'
require_relative 'database_connection'

def truncate_table
  conn = DatabaseConnection.connection

  print "Tem certeza que deseja esvaziar a tabela 'patients'? (Sim/Não): "
  choice = gets.chomp.downcase

  if choice == 'sim' || choice == 's'
    conn.exec("TRUNCATE TABLE patients CASCADE;")
    puts "Tabela 'patients' esvaziada com sucesso!"
  else
    puts "Operação cancelada."
  end
ensure
  conn.close if conn
end

truncate_table
