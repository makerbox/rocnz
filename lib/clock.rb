require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork

  handler do |job|
    puts "Running #{job}"
  end

  every(30.minutes, 'populate') { Delayed::Job.enqueue PopulateJob.new}
end