
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative '../PI/snapshot'
require_relative '../pi/change_set'


class PIExtractor

  def t
    PI::Change.new('09/16/2015', '4', '291.22')
  end

end

PIExtractor.new.t

