module SandboxHelper

  def get_lable_class(snapshot)
    if(snapshot.status == "success")
      return "label-success"
    else
      return "label-danger"
    end
  end

  def get_tr_class(snapshot)
    if(apac_has_failure_or_notrun?(snapshot))
      return "danger"
    else
      if(snapshot.status == "success")
        return "allsuccess"
      else
        return "success"
      end
    end
  end

  def apac_has_failure_or_notrun?(snapshot)
    return !((snapshot.mstest_failures == "0") && (snapshot.selenium_failures == "0"))
  end

  def get_status_class(status)
    if(status == "success")
      return "success"
    else
      return "failed"
    end
  end

  def get_status_str(status)
    if(status == "success")
      return "Pass"
    else
      return "Fail"
    end
  end

  def get_failure_str(failure)
    if(failure == 'Pending')
      return "..."
    elsif(failure == 'NoTestsRan')
      return "-"
    else
      return failure
    end
  end
end
