class Test
  attr_reader :type, :limits, :result

  def initialize(type:, limits:, result:)
    @type = type
    @limits = limits
    @result = result
  end

  def to_hash
    {
      type: @type,
      limits: @limits,
      result: @result
    }
  end
end
