describe 'Index Page' do
  it 'displays the title' do
    visit 'http://localhost:3000/home'

    expect(page).to have_content('Lista Médica')
  end
end
