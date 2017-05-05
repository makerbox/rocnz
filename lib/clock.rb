require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

handler do |job|
	puts 'doingggg the jorb -- #{job}'
end

every(40.minutes, 'porpulate') { SuckerPunch::Job.enqueue PopulateJob.new}