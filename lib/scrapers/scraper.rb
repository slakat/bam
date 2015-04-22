module Scrapers

    class Scraper 
    	@scrapers

    	def initialize
    		@scrapers = Array.new
    		@scrapers[0] = Scrapers.LaboralScrapper.new
    		#@scrapers[1] = Scrapers.LaboralScrapper.new
    		#@scrapers[2] = Scrapers.LaboralScrapper.new
    		#@scrapers[3] = Scrapers.LaboralScrapper.new
    		#@scrapers[4] = Scrapers.LaboralScrapper.new
    	end


    	def get_causas_by_rut rut
    		@scrapers.each do |scraper|
    			scraper.get_causas_by_rut rut
    		end
    	end

    	def get_causas_by_name rut
    		
    	end

    	def get_causas_by_last_name rut
    		
    	end



	end

end