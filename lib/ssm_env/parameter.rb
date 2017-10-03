class Parameter
  attr_accessor :value
  attr_reader :name, :type

  def initialize(name: , type: :string)
    @name, @type = name, type
  end

  def to_env!
    ENV[@name.to_sym] = value
  end
end