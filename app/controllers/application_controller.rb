class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

helper_method :checksort
def checksort
	if user_signed_in?
		if !current_user.has_role? :admin #if they ain't admin - they just have normal sort
			@sort = current_user.account.sort
		else
			if current_user.mimic #if they is admin and have mimic - give them mimic sort
				@sort = current_user.mimic.account.sort
			else #if they admin without mimic - they get full sort
				@sort = 'R L U P'
			end
		end
	end
	return @sort
end

end