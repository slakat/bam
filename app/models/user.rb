class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise 		:database_authenticatable, :registerable,
         		:recoverable, :rememberable, :trackable, :validatable

	has_one		:account

	def to_s
		"#{self.account.name} #{self.account.lastname}"
	end

	def is? requested_role
    unless self.account.nil?
      self.account.role == requested_role.to_s 
    else
      false
    end
  end


end
