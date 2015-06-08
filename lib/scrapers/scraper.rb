module Scrapers

  class Scraper 
    @scrapers

    def initialize
      @scrapers = Array.new
      @scrapers[0] = CivilScraper
      @scrapers[1] = CorteScraper
      @scrapers[2] = LaboralScraper
      @scrapers[3] = SupremaScraper
      @scrapers[4] = ProcesalScraper
   	end


    def search_by_name(a, b, c, user)
      @scrapers.each do |scraper|
        t = Thread.new { scraper.search_by_name a, b, c, user }
      end
    end

  	def search_by_rut(input, user)
  		@scrapers[0..3].each do |scraper|
        t = Thread.new { scraper.search_by_rut input, user }
      end
  	end


	end

end