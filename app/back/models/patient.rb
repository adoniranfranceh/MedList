class Patient
  attr_reader :id, :cpf, :name, :email, :birthday, :address, :city, :state, :medical_crm

  def initialize(id:, cpf:, name:, email:, birthday:, address:, city:, state:, medical_crm:)
    @id = id
    @cpf = cpf
    @name = name
    @email = email
    @birthday = birthday
    @address = address
    @city = city
    @state = state
    @medical_crm = medical_crm
  end

  def self.all
    conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')
    result = conn.exec("SELECT * FROM patients")

    patients = result.map do |row|
      Patient.new(
        id: row['id'],
        cpf: row['cpf'],
        name: row['name'],
        email: row['email'],
        birthday: row['birthday'],
        address: row['address'],
        city: row['city'],
        state: row['state'],
        medical_crm: row['medical_crm']
      )
    end

    conn.close
    patients
  end

  def self.search(term)
    conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'db')
    result = conn.exec_params("SELECT * FROM patients WHERE name ILIKE $1", ["%#{term}%"])

    patients = result.map do |row|
      Patient.new(
        id: row['id'],
        cpf: row['cpf'],
        name: row['name'],
        email: row['email'],
        birthday: row['birthday'],
        address: row['address'],
        city: row['city'],
        state: row['state'],
        medical_crm: row['medical_crm']
      )
    end

    conn.close
    patients
  end

  def to_hash
    {
      id: @id,
      cpf: @cpf,
      name: @name,
      email: @email,
      birthday: @birthday,
      address: @address,
      city: @city,
      state: @state,
      medical_crm: @medical_crm
    }
  end
end
