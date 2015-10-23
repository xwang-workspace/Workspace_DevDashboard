require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'

module Lift

  class Build
    attr_accessor :number, :time, :result

    SOURCE_URL_BUILD_LIST = "http://jenkins.cb-apac.com/job/LiFT-Protractor/api/xml"
    SOURCE_URL_BUILD_DETAIL = "http://jenkins.cb-apac.com/job/LiFT-Protractor/{job id}/api/xml"

    def initialize(number)
      @number = number
    end

    def self.get_builds(latest_num)
      builds = []
      build_list = get_build_list(latest_num)

      build_list.each do  |item|
        builds << get_build_detail(item)
      end

      return builds
    end

    def self.get_build_list(latest_num)
      page = Nokogiri::XML(open(Lift::Build::SOURCE_URL_BUILD_LIST, http_basic_authentication: [ENV['LiFT_JENKINS_USERNAME'], ENV['LiFT_JENKINS_PASSWORD']]))

      build_list = []
      list_node = page.xpath('//freeStyleProject//build')
      list_node.take(latest_num).each do |build_node|
        build = Nokogiri::XML(build_node.to_s)
        build_list << Build.new(build.xpath('//number').text)
      end

      return build_list
    end

    def self.get_build_detail(build)
      page = Nokogiri::XML(open(get_build_detail_url(build.number), http_basic_authentication: [ENV['LiFT_JENKINS_USERNAME'], ENV['LiFT_JENKINS_PASSWORD']]))

      build.result = page.xpath('//freeStyleBuild//result').text
      build.time = get_time(page.xpath('//freeStyleBuild//timestamp').text)

      return build
    end

    def self.get_build_detail_url(number)
      return Lift::Build::SOURCE_URL_BUILD_DETAIL.sub("{job id}", number.to_s)
    end

    def self.get_time(timestamp)
      time = DateTime.strptime((timestamp.to_i/1000).to_s,'%s')
      return time.to_time
    end



private


  end

end

# list = Lift::Build.get_builds(7)
# p list.size
#
# list.each do |item|
#   p item.number
#   p item.time
#   p item.result
# end

