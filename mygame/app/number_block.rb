class NumberBlock
  attr_sprite

  attr_reader :value, :id, :h
  attr_accessor :x, :y, :action

  def initialize(x:, y:, value:, id:)
    @x = x
    @y = y
    @w = 64
    @h = 64
    # temporary
    @path = "sprites/numbers/square-#{value}.png"
    @value = value
    @id = id
    @action = :sitting
  end
end
