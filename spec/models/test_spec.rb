require_relative '../../app/back/models/test'

RSpec.describe Test do
  describe '#initialize' do
    it 'cria uma nova instância de test' do
      test = Test.new(type: 'hemoglobin', limits: '12-16', result: '14')
      expect(test.type).to eq('hemoglobin')
      expect(test.limits).to eq('12-16')
      expect(test.result).to eq('14')
    end
  end

  describe '#to_hash' do
    it 'retorna hash de test' do
      test = Test.new(type: 'hemoglobin', limits: '12-16', result: '14')
      expect(test.to_hash).to eq({ type: 'hemoglobin', limits: '12-16', result: '14' })
    end
  end
end
