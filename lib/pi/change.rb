require 'nokogiri'
require 'open-uri'


module PI

## 这个代表某个时点的修改(包括代码修改、或者SCP修改)
class Change
  attr_accessor :date, :hour, :version, :modified_by

  MEMBER_OF_APACLOCAL = ['xwang', 'khou', 'slian', 'xzeng', 'yzhu', 'boowilson']

  def initialize(date, hour, version)
    @date = date
    @hour = hour
    @version = version
    if(! @version.empty?)
      @modified_by = get_modified_by(get_content(get_change_url(date, hour, version)))
    end
  end

  def to_s
    return "#{date} #{hour}:00 version:#{version} modified by:#{modified_by}"
  end




  protected

  def get_base_url
    raise NotImplementedError.new("#{self.class.name}#get_base_url是抽象方法")
  end

  def get_modified_by(inner_html)
    raise NotImplementedError.new("#{self.class.name}#get_modified_by是抽象方法")
  end

  def get_change_url(date, hour, version)
    return "#{get_base_url}?Date=#{date}&Hour=#{hour}&Version=#{version}"
  end



  private

  def get_content(source)
    p source

    page = Nokogiri::HTML(open(source))

    p page.css('section.main-content').inner_html

    return page.css('section.main-content').inner_html
  end

end

end


