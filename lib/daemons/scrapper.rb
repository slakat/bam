#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

#while($running) do
  
  
scraper = Scrapers::Scraper.new
User.all.each do |user|
	scraper.search_by_rut user.rut, user
	scraper.search_by_name user.name, user.lastname.split(" ")[0], user.lastname.split(" ")[1], user		
end

Account.all.each do |user|
	scraper.search_by_rut user.rut, user
	scraper.search_by_name user.name, user.lastname.split(" ")[0], user.lastname.split(" ")[1], user		
end
  
  #sleep 10
#end
