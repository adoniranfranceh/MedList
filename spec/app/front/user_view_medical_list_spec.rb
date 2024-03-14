describe 'Usuário vê lista médica' do
  it 'com sucesso', js: true do
    visit '/home'

    expect(page).to have_css('#patient-list li', count: 50)
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Antônio Rebouças')
  end

  it 'e vê detalhes de um paciente', js: true do
    visit '/home'

    find('li', text: 'Emilly Batista Neto').click

    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('IQCZ17')
    expect(page).to have_content('CPF: 048.973.170-88')
    expect(page).to have_content('Email: gerald.crona@ebert-quigley.com')
    expect(page).to have_content('Data de Nascimento: 2001-03-11')
    expect(page).to have_content('Endereço: 165 Rua Rafaela, Ituverava - Alagoas')
    within('#doctor-details') do
      expect(page).to have_content('Nome: Maria Luiza Pires')
      expect(page).to have_content('CRM: B000BJ20J4')
      expect(page).to have_content('Estado CRM: PI')
    end

    within('#patient-tests') do
      expect(page).to have_content('hemácias: 97 (45-52)')
      expect(page).to have_content('leucócitos: 89 (9-61)')
      expect(page).to have_content('plaquetas: 97 (11-93)')
      expect(page).to have_content('hdl: 0 (19-75)')
      expect(page).to have_content('ldl: 80 (45-54)')
      expect(page).to have_content('vldl: 82 (48-72)')
      expect(page).to have_content('glicemia: 98 (25-83)')
      expect(page).to have_content('tgo: 87 (50-84)')
      expect(page).to have_content('tgp: 9 (38-63)')
      expect(page).to have_content('eletrólitos: 85 (2-68)')
      expect(page).to have_content('tsh: 65 (25-80)')
      expect(page).to have_content('t4-livre: 94 (34-60)')
      expect(page).to have_content('ácido úrico: 2 (15-61)')
    end
  end

  it 'e pesquisa por nome', js: true do
    visit '/home'

    fill_in 'search-input-per-name', with: 'Lara Guedes'
    sleep 1

    expect(page).to have_css('#patient-list li', count: 1)
    expect(page).to have_content('Lara Guedes')
  end


  it 'e pesquisa por token', js: true do
    visit '/home'

    click_on 'Pesquisar por token'
    fill_in 'search-input-per-token', with: '0W9I67'
    sleep 1

    expect(page).to have_css('#patient-list li', count: 1)
    expect(page).to have_content('Juliana dos Reis Filho')
  end
end
