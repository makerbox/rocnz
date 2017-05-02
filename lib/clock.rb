require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

handler { |job| Delayed::Job.enqueue job }

every(1.hours, 'PopulateJob.new.perform')