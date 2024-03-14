describe 'Usuário pesquisa por paciênte' do
  it 'e pesquisa por nome', js: true do
    visit '/home'

    fill_in 'search-input-per-name', with: 'Lara Guedes'
    sleep 2

    expect(page).to have_css('#patient-list li', count: 1)
    expect(page).to have_content('Lara Guedes')
  end

  it 'e não encontra resultados para a pesquisa por nome', js: true do
    visit '/home'
  
    fill_in 'search-input-per-name', with: 'Nome Que Não Existe'
  
    expect(page).to have_content('Nenhum resultado para a busca por nome')
  end

  it 'e pesquisa por token', js: true do
    visit '/home'

    click_on 'Pesquisar por token'
    fill_in 'search-input-per-token', with: '0W9I67'
    sleep 2

    expect(page).to have_css('#patient-list li', count: 1)
    expect(page).to have_content('Juliana dos Reis Filho')
  end

  it 'e não encontra resultados para a pesquisa por toke', js: true do
    visit '/home'

    click_on 'Pesquisar por token'
  
    fill_in 'search-input-per-token', with: 'Token Que Não Existe'
    sleep 2
  
    expect(page).to have_content('Nenhum resultado para a busca por token')
  end
end