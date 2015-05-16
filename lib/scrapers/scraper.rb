module Scrapers

    class Scraper 
    	@scrapers

    	def initialize
    		@scrapers = Array.new
    		@scrapers[0] = Scrapers::CivilScraper.new
    		@scrapers[1] = Scrapers::CorteScraper.new
    		@scrapers[2] = Scrapers::LaboralScraper.new
    		@scrapers[3] = Scrapers::SupremaScraper.new
            @scrapers[4] = Scrapers::ProcesalScraper.new
    	end


    	def search_by_name(a, b, c, user)
    		@scrapers.each do |scraper|
                scraper.find_by_name a,b,c
            end
    	end

    	def self.search_by_rut(input, user)
    		@scrapers[0..3].each do |scraper|
                scraper.find_by_rut input
            end
    	end


	end

end