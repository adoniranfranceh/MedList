require_relative '../../app/back/models/patient'
require_relative '../../app/back/import_from_csv'

describe Patient do
  describe '#initialize' do
    it 'define os atributos corretamente' do
      patient = Patient.new(
        id: '1',
        cpf: '123.456.789-00',
        name: 'John Doe',
        email: 'john@example.com',
        birthday: '1990-01-01',
        address: '123 Main St',
        city: 'Anytown',
        state: 'ST',
        medical_crm: '12345'
      )

      expect(patient.id).to eq('1')
      expect(patient.cpf).to eq('123.456.789-00')
      expect(patient.name).to eq('John Doe')
      expect(patient.email).to eq('john@example.com')
      expect(patient.birthday).to eq('1990-01-01')
      expect(patient.address).to eq('123 Main St')
      expect(patient.city).to eq('Anytown')
      expect(patient.state).to eq('ST')
      expect(patient.medical_crm).to eq('12345')
    end
  end

  describe '.all' do
    it 'retorna todos os pacientes do banco de dados' do
      conn = double('PG connection')
      allow(conn).to receive(:close)
      allow(PG).to receive(:connect).and_return(conn)
    
      file_path = File.expand_path('../json/patients.json', __dir__)
      json_data = File.read(file_path)
      patients_data = JSON.parse(json_data)
      allow(conn).to receive(:exec).with("SELECT * FROM patients").and_return(patients_data)
    
      patients = Patient.all
      expect(patients.length).to eq(2)
      expect(patients[0].id).to eq(1)
      expect(patients[0].cpf).to eq('123.456.789-10')
      expect(patients[0].name).to eq('João da Silva')
      expect(patients[0].email).to eq('joao@example.com')
      expect(patients[0].birthday).to eq('1990-05-15')
      expect(patients[0].address).to eq('Rua A, 123')
      expect(patients[0].city).to eq('São Paulo')
      expect(patients[0].state).to eq('SP')
      expect(patients[0].medical_crm).to eq('CRM12345')
    
      expect(patients[1].id).to eq(2)
      expect(patients[1].cpf).to eq('987.654.321-98')
      expect(patients[1].name).to eq('Maria Souza')
      expect(patients[1].email).to eq('maria@example.com')
      expect(patients[1].birthday).to eq('1985-10-20')
      expect(patients[1].address).to eq('Avenida B, 456')
      expect(patients[1].city).to eq('Rio de Janeiro')
      expect(patients[1].state).to eq('RJ')
      expect(patients[1].medical_crm).to eq('CRM54321')
    end
  end

  describe '.search' do
    it 'pesquisa por nome do paciente' do
      conn = double('PG connection')
      allow(conn).to receive(:close)
      allow(PG).to receive(:connect).and_return(conn)

      file_path = File.expand_path('../json/patients.json', __dir__)
      json_data = File.read(file_path)
      patients_data = JSON.parse(json_data)
      allow(conn).to receive(:exec_params).with("SELECT * FROM patients WHERE name ILIKE $1", ['%Mari%']).and_return([patients_data[1]])
      patients = Patient.search('Mari')

      expect(patients[0].id).to eq(2)
      expect(patients[0].cpf).to eq('987.654.321-98')
      expect(patients[0].name).to eq('Maria Souza')
      expect(patients[0].email).to eq('maria@example.com')
      expect(patients[0].birthday).to eq('1985-10-20')
      expect(patients[0].address).to eq('Avenida B, 456')
      expect(patients[0].city).to eq('Rio de Janeiro')
      expect(patients[0].state).to eq('RJ')
      expect(patients[0].medical_crm).to eq('CRM54321')
    end
  end

  describe '#to_hash' do
    it 'retorna os atributos como um hash' do
      patient = Patient.new(
        id: '1',
        cpf: '123.456.789-00',
        name: 'John Doe',
        email: 'john@example.com',
        birthday: '1990-01-01',
        address: '123 Main St',
        city: 'Anytown',
        state: 'ST',
        medical_crm: '12345'
      )

      expect(patient.to_hash).to eq({
        id: '1',
        cpf: '123.456.789-00',
        name: 'John Doe',
        email: 'john@example.com',
        birthday: '1990-01-01',
        address: '123 Main St',
        city: 'Anytown',
        state: 'ST',
        medical_crm: '12345'
      })
    end
  end
end
