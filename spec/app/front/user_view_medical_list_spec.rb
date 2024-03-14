describe 'Usuário vê lista médica' do
  it 'com sucesso', js: true do
    visit '/home'

    expect(page).to have_css('#patient-list li', count: 50)
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Antônio Rebouças')
  end
end
