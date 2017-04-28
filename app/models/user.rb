class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  has_one :account
  has_one :mimic
  has_many :orders
  
  after_create :assign_default_role

  def assign_default_role
  		add_role(:user)
  end

  def checksort(user)
    if user.has_role? :admin
      if user.mimic
        output = user.mimic.account.sort
        output = 'R'
      else
        output = 'R L U P'
      end
    else
      output = user.account.sort
    end
    return output
  end 

end
