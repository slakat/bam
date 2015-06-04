class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise 		:database_authenticatable, :registerable,
         		:recoverable, :rememberable, :trackable, :validatable

	has_one		:account
  after_commit  :find_causas, on: :create

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


  def find_causas
    scraper = Scrapers::Scraper.new
    scraper.search_by_name self.account.name, self.account.lastname.split(" ")[0], self.account.lastname.split(" ")[1], self.account
    scraper.search_by_rut self.account.rut, self.account
  end
end
