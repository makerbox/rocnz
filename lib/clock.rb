require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

handler do |job|
  puts "Running #{job}"
end

every(1.hours, 'populate') { Delayed::Job.enqueue PopulateJob.new.perform}