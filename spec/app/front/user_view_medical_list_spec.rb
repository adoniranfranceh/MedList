require 'net/http'
require 'json'
require 'webmock/rspec'

describe 'Usuário vê lista médica' do
  it 'com sucesso', js: true do
    WebMock.allow_net_connect!(net_http_connect_on_start: true, allow_localhost: true)
    stub_request(:get, "http://localhost:4567/tests/TTT").to_return(status: 200, body: Patient.all, headers: {})

    visit '/home'

    expect(page).to have_content('Emilly Batista Neto')
  end
end
