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

  def self.checksort
    if !self.has_role? :admin #if they ain't admin - they just have normal sort
      output = self.account.sort
    else
      if self.mimic #if they is admin and have mimic - give them mimic sort
        output = self.mimic.account.sort
      else #if they admin without mimic - they get full sort
        output = 'R L U P'
      end
    end
    return output
  end

end
