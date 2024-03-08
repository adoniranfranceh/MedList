require_relative 'doctor'
require_relative 'test'
require_relative '../helpers/database_helper'

class Patient
  extend DatabaseHelper
  attr_reader :result_token, :result_date, :cpf, :name, :email, :address, :city, :state, :birthday, :doctor, :tests

  def initialize(result_token:, result_date:, cpf:, name:, email:, address:, city:, state:, birthday:, doctor:, tests: [])
    @result_token = result_token
    @result_date = result_date
    @cpf = cpf
    @name = name
    @email = email
    @address = address
    @city = city
    @state = state
    @birthday = birthday
    @doctor = doctor
    @tests = tests
  end

  def self.all
    result = execute_query("SELECT * FROM patients")
    patients_with_tests_from_result(result)
  end

  def self.search(term)
    result = execute_query("SELECT * FROM patients WHERE name ILIKE $1", ["%#{term}%"])
    patients_with_tests_from_result(result)
  end

  def to_hash
    {
      result_token: @result_token,
      result_date: @result_date,
      cpf: @cpf,
      name: @name,
      email: @email,
      address: @address,
      city: @city,
      state: @state,
      birthday: @birthday,
      doctor: @doctor.to_hash,
      tests: @tests.map(&:to_hash)
    }
  end

  def self.execute_query(sql, params = [])
    conn = connect_database
    begin
      result = conn.exec_params(sql, params)
    ensure
      conn.close if conn
    end
    result
  end  

  def self.connect_database
    connect_to_database(ENV['RACK_ENV'].to_sym)
  end

  def self.patients_with_tests_from_result(result)
    patients = {}

    result.each do |row|
      cpf = row['cpf']
      patient = patients[cpf]

      unless patient
        patient = new(
          result_token: row['result_token'],
          result_date: row['result_date'],
          cpf: cpf,
          name: row['name'],
          email: row['email'],
          address: row['address'],
          city: row['city'],
          state: row['state'],
          birthday: row['birthday'],
          doctor: Doctor.new(
            crm: row['medical_crm'],
            crm_state: row['doctor_crm_state'],
            name: row['doctor_name']
          ),
          tests: []
        )
        patients[cpf] = patient
      end

      test_data = {
        type: row['test_type'],
        limits: row['test_limits'],
        result: row['test_result']
      }

      patient.tests << test_data unless patient.tests.any? { |test| test[:type] == test_data[:type] }
    end

    patients.values
  end
end
