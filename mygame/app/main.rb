require 'app/my_numbers.rb'

def tick(args)
  $my_numbers ||= MyNumbers.new(args)
  $my_numbers.args = args
  $my_numbers.tick
end

$gtk.reset
