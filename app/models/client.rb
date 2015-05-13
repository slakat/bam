class Client < ActiveRecord::Base
	has_many		:client_causas
	has_many		:general_causas, through: :client_causas

	# after_create	:find_causas

	# def find_causas
	# 	scraper = Scrapers::Scraper.new
	# 	scraper.search_by_name self.name, self.lastname.split(" ")[0], self.lastname.split(" ")[1]
	# 	scraper.search_by_rut self.rut
	# end
end
