module SandboxHelper

  def get_lable_class(snapshot)
    if(snapshot.is_pending?)
      return "label-default"
    end

    if(snapshot.status == "success")
      return "label-success"
    else
      return "label-danger"
    end
  end

  def get_lable_text(snapshot)
    if(snapshot.is_pending?)
      return "pending"
    end

    return snapshot.status
  end

  def get_tr_class(snapshot)
    if(snapshot.is_pending?)
      return "active"
    end

    if(snapshot.has_failure_or_notrun?)
      return "danger"
    else
      if(snapshot.status == "success")
        return "allsuccess"
      else
        return "success"
      end
    end
  end

  ## 获取状态栏当前状态的class信息
  def get_status_class(snapshot)
    if(snapshot.is_pending?)
      return "default"
    end

    if(snapshot.status == "success")
      return "success"
    else
      return "failed"
    end
  end

  ## 获取代码修改的class信息
  def get_code_change_status_class(snapshot)
    if (snapshot.code_changed_by_apaclocal?) then
      return 'ChangedByApaclocal'
    end

    return ''
  end

  ## 获取scp修改状态的class信息
  def get_scp_change_status_class(snapshot)
    if (snapshot.scp_changed_by_apaclocal?) then
      return 'ChangedByApaclocal'
    end

    return ''
  end

  ## 获取jenkins build状态的class信息
  def get_jenkins_td_class(build)
    if(build.result.downcase == "success")
      return "jenkinsSuccess"
    elsif(build.result.downcase == "failure")
      return "jenkinsFailure"
    else
      return "jenkinsOther"
    end
  end

  def get_failure_str(failure)
    if(failure == 'Pending')
      return "-"
    elsif(failure == 'NoTestsRan')
      return "-"
    else
      return failure
    end
  end

  def get_mstest_failure_percent(statistics_apac, statistics_global)
    if (statistics_global.num_of_mstest_failure == 0) then
      return "0"
    end

    return (((statistics_apac.num_of_mstest_failure*1.0)/statistics_global.num_of_mstest_failure) * 100).round(1).to_s + "%"
  end

  def get_selenium_failure_percent(statistics_apac, statistics_global)
    if (statistics_global.num_of_selenium_failure == 0) then
      return "0"
    end

    return (((statistics_apac.num_of_selenium_failure*1.0)/statistics_global.num_of_selenium_failure) * 100).round(1).to_s + "%"
  end

  ## 获取界面代码修改列表字符串的内容
  def get_changed_by_str(changed_by)
    if changed_by.nil? || changed_by.empty? then
      return ''
    end

    result = '  '
    changed_by.each do |item|
      if (PI::Change::MEMBER_OF_APACLOCAL.include?(item)) then
        result << %Q{<span class="label label-warning">#{item}</span>}
      else
        result << item
      end
      result << ', '
    end

    return result.rstrip.chop
  end
end
