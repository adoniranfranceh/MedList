def reset_database
  conn = PG.connect(
    dbname: 'myapp_test',
    user: 'postgres',
    password: 'postgres',
    host: 'db_test',
    port: 5432
  )

  if table_exists?(conn, 'patients')
    conn.exec("TRUNCATE TABLE patients CASCADE;")
  end

  conn.close
end
