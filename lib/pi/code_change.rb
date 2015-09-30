require 'nokogiri'
require 'open-uri'
require_relative '../pi/change'

module PI

class CodeChange < Change

  CODE_CHANGE_URL = 'http://pi.careerbuilder.com/Web/TeamPortal/Details/SourceControlChanges'



  protected

  def get_base_url
    return CODE_CHANGE_URL
  end

  def get_modified_by(inner_html)
    result = []
    content = Nokogiri::HTML(inner_html)
    content.css("div.changeset-container div.changeset-number").each do  |item|
      /CB\\DevUsr.*CB\\(.*)/ =~ item.content
      if $1 then
        result << $1.strip
      end
    end
    return result
  end

  private


end

end

