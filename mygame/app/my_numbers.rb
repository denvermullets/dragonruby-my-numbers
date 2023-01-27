class MyNumbers
  attr_gtk

  def initialize(_args)
    @sprites = [
      { x: 100, y: 100, w: 300, h: 300, path: 'sprites/misc/dragon-3.png', value: 1 },
      { x: 450, y: 450, w: 300, h: 300, path: 'sprites/misc/dragon-0.png', value: 2 }
    ]

    @dragging = nil
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
      next if sprite.value == stationary_sprite.value

      next unless geometry.intersect_rect?(stationary_sprite, sprite)

      outputs.labels << [10, 10.from_top, "#{sprite.value} hits #{stationary_sprite.value}"]
      # collision action here
    end
  end
end
