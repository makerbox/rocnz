require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

every(30.minutes, 'PopulateJob.perform') { Delayed::Job.enqueue PopulateJob.new}