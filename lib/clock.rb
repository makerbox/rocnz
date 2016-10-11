require 'clockwork'
require './config/boot'
require './config/environment'


every(30.minutes, 'populate') { Delayed::Job.enqueue PopulateJob.new}