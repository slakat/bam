class HomeController < ApplicationController
  def index
    eval(File.read 'scripts/search_by_rut.rb')
    puts @list
  end

  def wiselink_example_1
  end

  def wiselink_example_2
  end

  def modal_example
  end

  def theme
  end
end
