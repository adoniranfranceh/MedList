module DatabaseHelper
  def table_exists?(conn, table_name)
    result = conn.exec_params("SELECT EXISTS (
      SELECT FROM information_schema.tables 
      WHERE  table_schema = 'public' 
      AND    table_name   = $1
    );", [table_name])

    result.getvalue(0, 0) == 't'
  end

  def connect_to_database(environment)
    case environment
    when :development
      PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')
    when :test
      PG.connect(dbname: 'myapp_test', user: 'postgres', password: 'postgres', host: 'db_test')
    else
      raise ArgumentError, "Environment '#{environment}' not supported"
    end
  end
end
