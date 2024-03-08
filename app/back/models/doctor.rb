class Doctor
  attr_reader :crm, :crm_state, :name

  def initialize(crm:, crm_state:, name:)
    @crm = crm
    @crm_state = crm_state
    @name = name
  end

  def to_hash
    {
      crm: @crm,
      crm_state: @crm_state,
      name: @name
    }
  end
end
