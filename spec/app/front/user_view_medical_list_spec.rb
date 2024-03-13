describe 'Usuário vê lista médica' do
  it 'com sucesso', js: true do
    api_response =[
      {
        "result_token": "ABC1234",
        "result_date": "2024-03-07",
        "cpf": "123.456.789-10",
        "name": "João da Silva",
        "email": "joao@example.com",
        "address": "Rua A, 123",
        "city": "São Paulo",
        "state": "SP",
        "birthday": "1990-05-15",
        "doctor": {
          "crm": "CRM12345",
          "crm_state": "ST",
          "name": "Dr. Smith"
        },
        "tests": [
          {
            "type": "Blood Test",
            "result": "Normal",
            "limits": "Within normal range"
          },
          {
            "type": "X-Ray",
            "result": "Abnormal",
            "limits": "Requires further examination"
          }
        ]
      },
      {
        "result_token": "XYZ789",
        "result_date": "2024-03-07",
        "cpf": "987.654.321-98",
        "name": "Maria Souza",
        "email": "maria@example.com",
        "address": "Avenida B, 456",
        "city": "Rio de Janeiro",
        "state": "RJ",
        "birthday": "1985-10-20",
        "doctor": {
          "crm": "CRM54321",
          "crm_state": "RJ",
          "name": "Dr. Johnson"
        },
        "tests": [
          {
            "type": "Blood Test",
            "result": "Normal",
            "limits": "Within normal range"
          },
          {
            "type": "MRI",
            "result": "Normal",
            "limits": "No abnormalities detected"
          }
        ]
      }
    ].to_json
    allow(FetchPatient).to receive(:all).and_return(api_response)

    visit '/home'

    sleep 3

    expect(page).to have_css('#patient-list li', count: 50)
    expect(page).to have_content('Emilly Batista Neto')
  end
end
