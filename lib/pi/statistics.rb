

module PI

## 这个代表对一组测试快照的状态分析汇总
class Statistics
  attr_accessor :num_of_pass_snapshot, :num_of_fail_snapshot, :num_of_mstest_failure, :num_of_selenium_failure

  def initialize(snapshots, team)
    @num_of_pass_snapshot = 0
    @num_of_fail_snapshot = 0
    @num_of_mstest_failure = 0
    @num_of_selenium_failure = 0

    snapshots.each do |item|
      if (Success?(item, team)) then
        @num_of_pass_snapshot += 1
      else
        @num_of_fail_snapshot += 1
      end

      @num_of_mstest_failure += item.mstest_failures.to_i
      @num_of_selenium_failure += item.selenium_failures.to_i
    end
  end

  def to_s
    return "pass_snapshot(#{@num_of_pass_snapshot}), failed_snaphost(#{@num_of_fail_snaphost}), mstest_failure(#{@num_of_mstest_failure}), selenium_failure(#{@num_of_selenium_failure})"
  end


private

  def Success?(item, team)
    if (is_global_team?(team)) then
      return is_success_result?(item)
    else
      return !has_failure_or_notrun?(item)
    end
  end

  def is_success_result?(item)
    (item.status.downcase == 'success')
  end

  def is_global_team?(team)
    team == PI::Team::GLOBAL
  end

  def has_failure_or_notrun?(snapshot)
    return !((snapshot.mstest_failures == "0") && (snapshot.selenium_failures == "0"))
  end

end

end