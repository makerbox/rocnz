require 'clockwork'
include Clockwork

every(1.minutes, 'populate') { 
     system("RAILS_ENV=production bin/delayed_job start --exit-on-complete")
}