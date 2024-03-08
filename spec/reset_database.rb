def reset_database(conn, table_name)
  conn.exec("TRUNCATE TABLE patients CASCADE;") if table_exists?(conn, 'patients')

  conn.close
end
