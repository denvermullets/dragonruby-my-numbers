class NumberBlock
  attr_sprite

  attr_reader :value, :id

  def initialize(x:, y:, value:, id:)
    @x = x
    @y = y
    @w = 64
    @h = 64
    # temporary
    @path = "sprites/numbers/square-#{value}.png"
    @value = value
    @id = id
  end
end
