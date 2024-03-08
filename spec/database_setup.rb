require_relative '../app/back/helpers/database_helper'

def insert_patients_data(conn, patients_data)
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
end

def load_patients_data_from_json(file_path)
  json_data = File.read(file_path)
  JSON.parse(json_data)
end

def database_setup(conn)

  create_table(conn) unless table_exists?(conn, 'patients')

  file_path = File.expand_path('json/patients.json', __dir__)
  patients_data = load_patients_data_from_json(file_path)

  insert_patients_data(conn, patients_data)
end
