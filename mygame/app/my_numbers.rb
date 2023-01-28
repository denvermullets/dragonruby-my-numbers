require 'app/number_block.rb'

class MyNumbers
  attr_gtk

  # so we're going to need to have a method to calculate left, right, up, down collision borders
  # which will let us have each block have 'firmness' when the blocks fall due to gravity

  def initialize(_args)
    @sprites = [
      NumberBlock.new(x: 100, y: 100, value: 2, id: 1),
      NumberBlock.new(x: 450, y: 450, value: 1, id: 2),
      NumberBlock.new(x: 250, y: 250, value: 1, id: 3)
    ]

    @dragging = nil
    @gravity = -0.4
  end

  def tick
    state.mouse_held = true  if inputs.mouse.down
    state.mouse_held = false if inputs.mouse.up
    @dragging = nil if inputs.mouse.up

    check_dragging_sprite
    move_sprite

    outputs.sprites << @sprites
  end

  def sprite_click(x:, y:, sprite:)
    x > sprite.x && x < sprite.x + sprite.w && y > sprite.y && y < sprite.y + sprite.h
  end

  def check_dragging_sprite
    return unless inputs.mouse.click && state.mouse_held

    @sprites.each do |check_sprite|
      @dragging = sprite_click(x: inputs.mouse.x, y: inputs.mouse.y, sprite: check_sprite) && check_sprite

      break if @dragging
    end
  end

  def move_sprite
    if state.mouse_held && @dragging
      @dragging.x = inputs.mouse.x - (@dragging.w / 2)
      @dragging.y = inputs.mouse.y - (@dragging.h / 2)
      target_collision(@dragging)
    else
      @dragging = nil
    end
  end

  def target_collision(sprite)
    @sprites.each do |stationary_sprite|
      next if sprite.id == stationary_sprite.id

      next unless geometry.intersect_rect?(stationary_sprite, sprite)

      if sprite.value == stationary_sprite.value
        # this would be same numbers colliding
        # TODO: add animation for colliding blocks
        @sprites = @sprites.reject { |s| s.id == sprite.id || s.id == stationary_sprite.id }
      end
      outputs.labels << [10, 10.from_top, "#{sprite.id} hits #{stationary_sprite.id}"]
      outputs.labels << [10, 40.from_top, "#{sprite.value} hits #{stationary_sprite.value}"]
      # collision action here
    end
  end
end
