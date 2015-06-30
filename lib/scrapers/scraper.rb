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
        t = Thread.new {  scraper.search_by_name a, b, c, user }
      end

      t = Thread.new {
        aa = Scrapers::TypoGenerator.getAllTypos(a.downcase)      
        bb = Scrapers::TypoGenerator.getAllTypos(b.downcase)
        cc = Scrapers::TypoGenerator.getAllTypos(c.downcase)

        aa.each do |aaa|
          @scrapers.each do |scraper|
             scraper.search_by_name aaa, b, c, user
          end
        end
        bb.each do |bbb|
          @scrapers.each do |scraper|
            scraper.search_by_name a, bbb, c, user
          end
        end
        cc.each do |ccc|
          @scrapers.each do |scraper|
            scraper.search_by_name a, b, ccc, user
          end
        end
      }
    end

  	def search_by_rut(input, user)
  		@scrapers[0..3].each do |scraper|
        t = Thread.new { scraper.search_by_rut input, user }
      end
      t = Thread.new {
        aa = Scrapers::TypoGenerator.getAllTypos(input.downcase)      
        aa.each do |aaa|
          @scrapers[0..3].each do |scraper|
             scraper.search_by_rut aaa, user 
          end
        end
      }
  	end


	end

end