require 'spec_helper'

describe 'Usuário acessa página inicial' do
  it 'e vê mensagem' do
    get '/'

    expect(last_response.body).to eq 'Olá, acesse <a href="/tests">aqui</a> para obter a lista.'
  end
end
