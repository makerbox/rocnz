require 'clockwork'
include Clockwork

every(1.minutes, 'populate') { 
     system("rake runner:testdb")
puts 'bye'
      # Product.delay.populate
}