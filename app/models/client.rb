class Client < ActiveRecord::Base
	has_many		:client_causas
	has_many		:general_causas, through: :client_causas

	after_commit 	:find_causas, on: :create

	def find_causas
		scraper = Scrapers::Scraper.new
		scraper.search_by_rut self.rut, self
		scraper.search_by_name self.name, self.lastname.split(" ")[0], self.lastname.split(" ")[1], self

	end
end
