require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'date'

module Jenkins

  # 项目定义
  PROJECT_LIFT = 1
  PROJECT_TANK = 2
  PROJECT_AUTH = 3
  PROJECT_ARP = 4

  # Build URL定义
  LIFT_SOURCE_URL_BUILD_LIST = "http://jenkins.cbapac.net/job/LiFT-Build/api/xml"
  LIFT_SOURCE_URL_BUILD_DETAIL = "http://jenkins.cbapac.net/job/LiFT-Build/{job id}/api/xml"

  TANK_SOURCE_URL_BUILD_LIST = "http://jenkins.cbapac.net/job/Tank-Build/api/xml"
  TANK_SOURCE_URL_BUILD_DETAIL = "http://jenkins.cbapac.net/job/Tank-Build/{job id}/api/xml"

  AUTH_SOURCE_URL_BUILD_LIST = "http://jenkins.cbapac.net/job/FT-Shared-Build/api/xml"
  AUTH_SOURCE_URL_BUILD_DETAIL = "http://jenkins.cbapac.net/job/FT-Shared-Build/{job id}/api/xml"

  ARP_SOURCE_URL_BUILD_LIST = "http://jenkins.cbapac.net/job/ARP-Test-Environment-Build/api/xml"
  ARP_SOURCE_URL_BUILD_DETAIL = "http://jenkins.cbapac.net/job/ARP-Test-Environment-Build/{job id}/api/xml"


  class Build
    attr_accessor :number, :time, :result

    def initialize(number)
      @number = number
    end

    def self.get_builds(project, latest_num)
      builds = []
      build_list = get_build_list(project, latest_num)

      build_list.each do  |item|
        builds << get_build_detail(project, item)
      end

      return builds
    end


private

    def self.get_build_list(project, latest_num)
      page = get_page(get_build_list_url(project))

      build_list = []
      list_node = page.xpath('//freeStyleProject//build')
      list_node.take(latest_num).each do |build_node|
        build = Nokogiri::XML(build_node.to_s)
        build_list << Build.new(build.xpath('//number').text)
      end

      return build_list
    end

    def self.get_build_detail(project, build)
      page = get_page(get_build_detail_url(project, build.number))

      build.result = page.xpath('//freeStyleBuild//result').text
      build.time = get_time(page.xpath('//freeStyleBuild//timestamp').text)

      return build
    end

    def self.get_page(url)
      return Nokogiri::XML(open(url, http_basic_authentication: [ENV['LiFT_JENKINS_USERNAME'], ENV['LiFT_JENKINS_PASSWORD']]))
    end

    def self.get_build_list_url(project)
      case project
        when Jenkins::PROJECT_LIFT
          return Jenkins::LIFT_SOURCE_URL_BUILD_LIST
        when Jenkins::PROJECT_TANK
          return Jenkins::TANK_SOURCE_URL_BUILD_LIST
        when Jenkins::PROJECT_AUTH
          return Jenkins::AUTH_SOURCE_URL_BUILD_LIST
        when Jenkins::PROJECT_ARP
          return Jenkins::ARP_SOURCE_URL_BUILD_LIST
        else
          return ""
      end
    end

    def self.get_build_detail_url(project, number)
      case project
        when Jenkins::PROJECT_LIFT
          return Jenkins::LIFT_SOURCE_URL_BUILD_DETAIL.sub("{job id}", number.to_s)
        when Jenkins::PROJECT_TANK
          return Jenkins::TANK_SOURCE_URL_BUILD_DETAIL.sub("{job id}", number.to_s)
        when Jenkins::PROJECT_AUTH
          return Jenkins::AUTH_SOURCE_URL_BUILD_DETAIL.sub("{job id}", number.to_s)
        when Jenkins::PROJECT_ARP
          return Jenkins::ARP_SOURCE_URL_BUILD_DETAIL.sub("{job id}", number.to_s)
        else
          return ""
      end
    end

    def self.get_time(timestamp)
      time = DateTime.strptime((timestamp.to_i/1000).to_s,'%s')
      return time.to_time
    end

  end

end

# list = Jenkins::Build.get_builds(7)
# p list.size
#
# list.each do |item|
#   p item.number
#   p item.time
#   p item.result
# end

