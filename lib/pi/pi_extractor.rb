
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require_relative '../PI/snapshot'


class PIExtractor

  def t
    Snapshot.get_current_snapshots().each do |snapshot|
      p snapshot
    end
  end

end

