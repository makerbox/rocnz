require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(1.hours, `Delayed::Job.enqueue PopulateJob.new.perform`)