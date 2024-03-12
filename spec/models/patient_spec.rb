describe Patient do
  let(:doctor) { Doctor.new(crm: 'CRM123', crm_state: 'SP', name: 'Dr. Smith') }

  describe '#initialize' do
    it 'define os atributos corretamente' do
      patient = Patient.new(
        result_token: '1',
        result_date: '2022-01-01',
        cpf: '123.456.789-00',
        name: 'John Doe',
        email: 'john@example.com',
        address: '123 Main St',
        city: 'Anytown',
        state: 'ST',
        birthday: '1990-01-01',
        doctor: doctor,
        tests: []
      )

      expect(patient.result_token).to eq('1')
      expect(patient.result_date).to eq('2022-01-01')
      expect(patient.cpf).to eq('123.456.789-00')
      expect(patient.name).to eq('John Doe')
      expect(patient.email).to eq('john@example.com')
      expect(patient.address).to eq('123 Main St')
      expect(patient.city).to eq('Anytown')
      expect(patient.state).to eq('ST')
      expect(patient.birthday).to eq('1990-01-01')
      expect(patient.doctor).to eq(doctor)
      expect(patient.tests).to eq([])
    end
  end

  describe '.all' do
    it 'retorna todos os pacientes do banco de dados' do
      patients = Patient.all

      expect(patients.length).to eq(2)
      expect(patients[0].result_token).to eq('ABC1234')
      expect(patients[0].cpf).to eq('123.456.789-10')
      expect(patients[0].name).to eq('João da Silva')
      expect(patients[0].email).to eq('joao@example.com')
      expect(patients[0].birthday).to eq('1990-05-15')
      expect(patients[0].address).to eq('Rua A, 123')
      expect(patients[0].city).to eq('São Paulo')
      expect(patients[0].state).to eq('SP')
      expect(patients[0].doctor.crm).to eq('CRM12345')
      expect(patients[0].doctor.crm_state).to eq('ST')
      expect(patients[0].doctor.name).to eq('Dr. Smith')
    
      expect(patients[1].result_token).to eq('XYZ789')
      expect(patients[1].cpf).to eq('987.654.321-98')
      expect(patients[1].name).to eq('Maria Souza')
      expect(patients[1].email).to eq('maria@example.com')
      expect(patients[1].birthday).to eq('1985-10-20')
      expect(patients[1].address).to eq('Avenida B, 456')
      expect(patients[1].city).to eq('Rio de Janeiro')
      expect(patients[1].state).to eq('RJ')
      expect(patients[1].doctor.crm).to eq('CRM54321')
      expect(patients[1].doctor.crm_state).to eq('RJ')
      expect(patients[1].doctor.name).to eq('Dr. Johnson')
    end
  end

  describe '.search' do
    it 'pesquisa por nome do paciente' do
      patients = Patient.search('Mari')

      expect(patients[0].result_token).to eq('XYZ789')
      expect(patients[0].cpf).to eq('987.654.321-98')
      expect(patients[0].name).to eq('Maria Souza')
      expect(patients[0].email).to eq('maria@example.com')
      expect(patients[0].birthday).to eq('1985-10-20')
      expect(patients[0].address).to eq('Avenida B, 456')
      expect(patients[0].city).to eq('Rio de Janeiro')
      expect(patients[0].state).to eq('RJ')
      expect(patients[0].doctor.crm).to eq('CRM54321')
      expect(patients[0].doctor.crm_state).to eq('RJ')
      expect(patients[0].doctor.name).to eq('Dr. Johnson')
    end
  end

  describe '.search_per_token' do
    it 'pesquisa por nome do paciente' do
      patients = Patient.search_per_token('ABC1234')

      expect(patients[0].result_token).to eq('ABC1234')
      expect(patients[0].cpf).to eq('123.456.789-10')
      expect(patients[0].name).to eq('João da Silva')
      expect(patients[0].email).to eq('joao@example.com')
      expect(patients[0].birthday).to eq('1990-05-15')
      expect(patients[0].address).to eq('Rua A, 123')
      expect(patients[0].city).to eq('São Paulo')
      expect(patients[0].state).to eq('SP')
      expect(patients[0].doctor.crm).to eq('CRM12345')
      expect(patients[0].doctor.crm_state).to eq('ST')
      expect(patients[0].doctor.name).to eq('Dr. Smith')
    end
  end

  describe '#to_hash' do
    it 'retorna os atributos como um hash' do
      patient = Patient.new(
        result_token: '1',
        result_date: '2024-03-07',
        cpf: '123.456.789-00',
        name: 'John Doe',
        email: 'john@example.com',
        address: '123 Main St',
        city: 'Anytown',
        state: 'ST',
        birthday: '1990-01-01',
        doctor: Doctor.new(
          crm: 'CRM12345',
          crm_state: 'ST',
          name: 'Dr. Smith'
        ),
        tests: [
          Test.new(
            type: 'Blood Test',
            result: 'Normal',
            limits: 'Within normal range'
          ),
          Test.new(
            type: 'Head Test',
            result: 'Bad',
            limits: 'Without Head'
          )
        ]
      )

      expect(patient.to_hash).to eq({
        result_token: '1',
        result_date: '2024-03-07',
        cpf: '123.456.789-00',
        name: 'John Doe',
        email: 'john@example.com',
        address: '123 Main St',
        city: 'Anytown',
        state: 'ST',
        birthday: '1990-01-01',
        doctor: {
          crm: 'CRM12345',
          crm_state: 'ST',
          name: 'Dr. Smith'
        },
        tests: [
          { type: 'Blood Test',
            result: 'Normal',
            limits: 'Within normal range'
          },
          { type: 'Head Test',
            result: 'Bad',
            limits: 'Without Head'
          }
        ]
      })
    end
  end
end
