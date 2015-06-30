class Account < ActiveRecord::Base
	#Relaciones
	belongs_to		:user

	has_many			:user_causas
	has_many			:general_causas, through: :user_causas

	has_many			:searches

	has_many      :clients

	#Validaciones
	validates 		:name, :lastname, :rut, presence: true

	#Callbacks
	after_commit 	:find_causas, on: :create

	#Methods
	def find_causas
		scraper = Scrapers::Scraper.new
		scraper.search_by_rut self.rut, self
		scraper.search_by_name self.name, self.lastname.split(" ")[0], self.lastname.split(" ")[1], self		
	end

	def nombre
		name << " " << lastname
	end
	
end
