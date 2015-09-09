module SandboxHelper

  def get_lable_class(snapshot)
    if(is_pending?(snapshot))
      return "label-default"
    end

    if(snapshot.status == "success")
      return "label-success"
    else
      return "label-danger"
    end
  end

  def get_lable_text(snapshot)
    if(is_pending?(snapshot))
      return "pending"
    end

    return snapshot.status
  end

  def get_tr_class(snapshot)
    if(is_pending?(snapshot))
      return "active"
    end

    if(has_failure_or_notrun?(snapshot))
      return "danger"
    else
      if(snapshot.status == "success")
        return "allsuccess"
      else
        return "success"
      end
    end
  end

  def has_failure_or_notrun?(snapshot)
    return !((snapshot.mstest_failures == "0") && (snapshot.selenium_failures == "0"))
  end

  def is_pending?(snapshot)
    return (snapshot.mstest_failures == 'Pending')
  end

  def get_status_class(snapshot)
    if(is_pending?(snapshot))
      return "default"
    end

    if(snapshot.status == "success")
      return "success"
    else
      return "failed"
    end
  end

  def get_status_str(snapshot)
    if(is_pending?(snapshot)) #TODO 将is_pending等方法整理到snapshot对象内去
      return ": |"
    end

    if(snapshot.status == "success")
      return ": )"
    else
      return ": ("
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
end
