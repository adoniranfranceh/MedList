require_relative '../../create_tables'

describe 'create_table.rb' do
  describe '#create_schema' do
    it 'creates the public schema if it does not exist' do
      expect { create_schema }.not_to raise_error
    end

    it 'handles errors gracefully' do
      allow(PG).to receive(:connect).and_raise(PG::Error)
      expect { create_schema }.to raise_error
    end
  end

  describe '#create_table' do
    it 'creates the patients table if it does not exist' do
      expect { create_table }.not_to raise_error
    end

    it 'handles errors gracefully' do
      allow(PG).to receive(:connect).and_raise(PG::Error)
      expect { create_table }.to raise_error
    end
  end
end
