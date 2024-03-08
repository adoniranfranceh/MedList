describe 'table_exists?' do
  it 'retorna true se a tabela existir no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('t')
    allow(conn).to receive(:exec).and_return(query_result)

    expect(table_exists?(conn, 'table')).to eq(true)
  end

  it 'retorna false se a tabela não existir no banco de dados' do
    conn = double('PG::Connection')
    query_result = double('PG::Result')
    allow(query_result).to receive(:getvalue).with(0, 0).and_return('f')
    allow(conn).to receive(:exec).and_return(query_result)

    expect(table_exists?(conn, 'other_table')).to eq(false)
  end
end
