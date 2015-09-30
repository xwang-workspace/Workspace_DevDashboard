require 'nokogiri'
require 'open-uri'
require_relative '../pi/change'


module PI

  class SCPChange < Change

    SCP_CHANGE_URL = 'http://pi.careerbuilder.com/Web/TeamPortal/Details/SCPFlagChanges'

    protected

    def get_base_url
      return SCP_CHANGE_URL
    end

    def get_modified_by(inner_html)
      result = []
      content = Nokogiri::HTML(inner_html)
      content.css("div.scp-flag-changes div.flag-owner").each do  |item|
        result << item.content
      end
      return result
    end

    private


  end

end
