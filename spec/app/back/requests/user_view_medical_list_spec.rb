describe 'Usuário vê lista médica' do
  it 'com sucesso' do
    file_path = File.expand_path('../../../json/patients.json', __dir__)
    initial_json_data = JSON.parse(File.read(file_path))

    allow(Patient).to receive(:all).and_return(initial_json_data)

    get '/tests'

    expect(last_response.status).to eq(200)
    response_data = JSON.parse(last_response.body)

    expect(response_data.dig('patients', 0, 'name')).to eq('João da Silva')
    expect(response_data.dig('patients', 0, 'cpf')).to eq('123.456.789-10')
    expect(response_data.dig('patients', 0, 'email')).to eq('joao@example.com')
    expect(response_data.dig('patients', 0, 'birthday')).to eq('1990-05-15')
    expect(response_data.dig('patients', 0, 'address')).to eq('Rua A, 123')
    expect(response_data.dig('patients', 0, 'city')).to eq('São Paulo')
    expect(response_data.dig('patients', 0, 'state')).to eq('SP')
    expect(response_data.dig('patients', 0, 'doctor', 'crm')).to eq('CRM12345')

    expect(response_data.dig('patients', 1, 'name')).to eq('Maria Souza')
    expect(response_data.dig('patients', 1, 'cpf')).to eq('987.654.321-98')
    expect(response_data.dig('patients', 1, 'email')).to eq('maria@example.com')
    expect(response_data.dig('patients', 1, 'birthday')).to eq('1985-10-20')
    expect(response_data.dig('patients', 1, 'address')).to eq('Avenida B, 456')
    expect(response_data.dig('patients', 1, 'city')).to eq('Rio de Janeiro')
    expect(response_data.dig('patients', 1, 'state')).to eq('RJ')
    expect(response_data.dig('patients', 1, 'doctor', 'crm')).to eq('CRM54321')
  end

  it 'por filtragem' do
    file_path = File.expand_path('../../../json/patients.json', __dir__)
    initial_json_data = JSON.parse(File.read(file_path))

    allow(Patient).to receive(:all).and_return(initial_json_data)

    get '/tests?search=Silva'

    expect(last_response.status).to eq(200)
    response_data = JSON.parse(last_response.body)

    expect(response_data.dig('patients', 0, 'name')).to eq('João da Silva')
    expect(response_data.dig('patients', 0, 'cpf')).to eq('123.456.789-10')
    expect(response_data.dig('patients', 0, 'email')).to eq('joao@example.com')
    expect(response_data.dig('patients', 0, 'birthday')).to eq('1990-05-15')
    expect(response_data.dig('patients', 0, 'address')).to eq('Rua A, 123')
    expect(response_data.dig('patients', 0, 'city')).to eq('São Paulo')
    expect(response_data.dig('patients', 0, 'state')).to eq('SP')
    expect(response_data.dig('patients', 0, 'doctor', 'crm')).to eq('CRM12345')

    expect(response_data.dig('patients', 1, 'name')).not_to eq('Maria Souza')
    expect(response_data.dig('patients', 1, 'cpf')).not_to eq('987.654.321-98')
    expect(response_data.dig('patients', 1, 'email')).not_to eq('maria@example.com')
    expect(response_data.dig('patients', 1, 'birthday')).not_to eq('1985-10-20')
    expect(response_data.dig('patients', 1, 'address')).not_to eq('Avenida B, 456')
    expect(response_data.dig('patients', 1, 'city')).not_to eq('Rio de Janeiro')
    expect(response_data.dig('patients', 1, 'state')).not_to eq('RJ')
    expect(response_data.dig('patients', 1, 'doctor', 'crm')).not_to eq('CRM54321')
  end

  it 'e está vazia' do
    allow(Patient).to receive(:all).and_return([])

    get '/tests'

    expect(last_response.status).to eq(200)
    response_data = JSON.parse(last_response.body)

    expect(response_data.dig('patients', 'message')).to eq('Não há lista médica')
  end
end
