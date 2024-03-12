RSpec.describe Doctor do
  describe '#initialize' do
    it 'cria um nova instância doctor' do
      doctor = Doctor.new(crm: '12345', crm_state: 'SP', name: 'John Doe')
      expect(doctor.crm).to eq('12345')
      expect(doctor.crm_state).to eq('SP')
      expect(doctor.name).to eq('John Doe')
    end
  end

  describe '#to_hash' do
    it 'retornar um hash de doctor' do
      doctor = Doctor.new(crm: '12345', crm_state: 'SP', name: 'John Doe')
      expect(doctor.to_hash).to eq({ crm: '12345', crm_state: 'SP', name: 'John Doe' })
    end
  end
end
