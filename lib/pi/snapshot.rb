
require 'rubygems'
require 'nokogiri'
require 'open-uri'

module PI

## 这个代表某个时点的测试快照
class Snapshot
  attr_accessor :time, :version, :hour, :status, :code_change, :scp_change, :mstest_failures, :selenium_failures, :deployment_status

  SOURCE_URL_GLOBAL = "http://pi.careerbuilder.com/web/teamportal"
  SOURCE_URL_APAC = "http://pi.careerbuilder.com/web/TeamPortal/APACLocal"

  def initialize(tr_node_inner_html, date)
    td_node_contents = []

    tr_node_inner_html.css('td').each do |td_node|
      td_node_contents << td_node.content.gsub(/\s+/,'')
    end

    @time = get_time(date, td_node_contents[1].to_i)
    @version = td_node_contents[0]
    @hour = td_node_contents[1]
    @status = td_node_contents[2]
    @code_change = td_node_contents[3]
    @scp_change = td_node_contents[4]
    @mstest_failures = td_node_contents[5]
    @selenium_failures = td_node_contents[6]
    @deployment_status = td_node_contents[7]
  end

  def self.get_current_snapshots(source)
    snapshots = []

    table_inner_html = Nokogiri::HTML(get_table_content(source))

    table_inner_html.css("tr").each do  |tr_node|
      if(is_table_head_row?(tr_node.inner_html))
        next
      end

      if(is_date_row?(tr_node.inner_html))
        @time = Time.parse(tr_node.content)
        next
      end

      snapshots << Snapshot.new(Nokogiri::HTML(tr_node.inner_html), @time)
    end

    return snapshots
  end

  def to_s
    return "#{@time}, version #{@version} get #{@status} result, mstest failure(#{@mstest_failures}), selenium failure(#{@selenium_failures}); code change(#{@code_change}), SCP change(#{@scp_change})"
  end



private

  def get_time(date, hour)
    return (date + (hour * 60 * 60)).strftime("%Y-%m-%d %H:00")
  end

  def self.is_table_head_row?(node_content)
    return node_content.include? "th"
  end

  def self.is_date_row?(node_content)
    return node_content.include? ","
  end

  def self.get_table_content(source)
    page = Nokogiri::HTML(open(source))
    return page.css('table.team-hourly-metrics-table').inner_html
  end

end

end
