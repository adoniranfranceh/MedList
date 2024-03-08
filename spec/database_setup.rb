require 'pg'
require 'json'

def database_setup
  conn = PG.connect(
    dbname: 'myapp_test',
    user: 'postgres',
    password: 'postgres',
    host: 'db_test',
    port: 5432
  )

  conn.exec("CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    result_token VARCHAR(255),
    result_date DATE,
    cpf VARCHAR(14),
    name VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(2),
    birthday DATE,
    medical_crm VARCHAR(255),
    doctor_name VARCHAR(255),
    doctor_crm_state VARCHAR(255),
    test_type VARCHAR(255),
    test_limits VARCHAR(255),
    test_result VARCHAR(255)
  );")

  file_path = File.expand_path('json/patients.json', __dir__)
  json_data = File.read(file_path)
  patients_data = JSON.parse(json_data)

  patients_data.each do |patient|
    patient['tests'].each do |test|
      conn.exec_params("INSERT INTO patients (result_token, result_date, cpf, name, email, address, city, state, birthday, medical_crm, doctor_name, doctor_crm_state, test_type, test_limits, test_result) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)",
                       [
                         patient['result_token'],
                         patient['result_date'],
                         patient['cpf'],
                         patient['name'],
                         patient['email'],
                         patient['address'],
                         patient['city'],
                         patient['state'],
                         patient['birthday'],
                         patient['doctor']['crm'],
                         patient['doctor']['name'],
                         patient['doctor']['crm_state'],
                         test['type'],
                         test['limits'],
                         test['result']
                       ])
    end
  end  

  conn.close
end
