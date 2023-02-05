require 'app/number_block.rb'

class MyNumbers
  attr_gtk

  # so we're going to need to have a method to calculate left, right, up, down collision borders
  # which will let us have each block have 'firmness' when the blocks fall due to gravity

  def initialize(args)
    @sprites = [
      NumberBlock.new(x: 600, y: 100, value: 2, id: 1),
      NumberBlock.new(x: 950, y: 450, value: 1, id: 2),
      NumberBlock.new(x: 750, y: 250, value: 1, id: 3)
    ]

    @dragging = nil
    @gravity = 4
    @collision = nil
    @past_x = args.inputs.mouse.x
    @past_y = args.inputs.mouse.y
  end

  def tick
    state.mouse_held = true  if inputs.mouse.down
    state.mouse_held = false if inputs.mouse.up
    @dragging = nil if inputs.mouse.up
    @collision = nil if inputs.mouse.up

    check_dragging_sprite
    drag_sprite
    # @dragging && square_collision(@dragging)
    gravity
    render
    debug_stuff
  end

  def render
    outputs.sprites << @sprites
  end

  def debug_stuff
    outputs.labels << [10, 100.from_bottom, "FPS: #{$gtk.current_framerate.round(2)}"]
    outputs.labels << [10, 40.from_bottom, "x: #{inputs.mouse.x}, y: #{inputs.mouse.y}"]
    outputs.labels << [10, 20.from_bottom, "past_x: #{@past_x}, past_y: #{@past_y}"]
  end

  def check_dragging_sprite
    return unless inputs.mouse.click && state.mouse_held

    @sprites.each do |sprite|
      @dragging = inputs.mouse.inside_rect?(sprite) && sprite

      break if @dragging
    end
  end

  def drag_sprite
    if state.mouse_held && @dragging
      @collision ||= @sprites.find { |sprite| geometry.intersect_rect?(@dragging, sprite) && sprite.id != @dragging.id }
      if @collision && (@past_x > inputs.mouse.x) && (inputs.mouse.x < (@dragging.x + (@dragging.w / 2)))
        # dragging left
        puts 'moving'
        @dragging.x = inputs.mouse.x - (@dragging.w / 2)
        @dragging.y = inputs.mouse.y - (@dragging.h / 2)
        @collision = nil
        @past_x = nil
        @past_y = nil
      elsif @collision
        @dragging.x = @collision.x - 64
        @dragging.y = inputs.mouse.y - (@dragging.h / 2)
      else
        @dragging.x = inputs.mouse.x - (@dragging.w / 2)
        @dragging.y = inputs.mouse.y - (@dragging.h / 2)
      end

      @past_x = inputs.mouse.x
      @past_y = inputs.mouse.y
    else
      @dragging = nil
    end
  end

  def gravity
    @sprites.each do |sprite|
      # square_collision(sprite)
      sprite.y -= @gravity
      border_y(sprite)
    end
  end

  def border_y(sprite)
    sprite.y + sprite.h > grid.h && sprite.y = grid.h - sprite.h
    sprite.y.negative? && sprite.y = 0
  end

  # def square_collision(sprite)
  #   @sprites.each do |second_sprite|
  #     next if sprite.id == second_sprite.id

  #     @collision = geometry.intersect_rect?(second_sprite, sprite) ? second_sprite : nil

  #     if @collision
  #       if @dragging && @dragging.id == sprite.id
  #         puts 'left side collision'
  #         sprite.x = second_sprite.x - 64
  #         inputs.mouse.x = second_sprite.x - 32
  #       end

  #       outputs.labels << [10, 10.from_top, "#{sprite.id} hits #{second_sprite.id}"]
  #       outputs.labels << [10, 40.from_top, "#{sprite.value} hits #{second_sprite.value}"]
  #     end
  #   end
  # end
end
