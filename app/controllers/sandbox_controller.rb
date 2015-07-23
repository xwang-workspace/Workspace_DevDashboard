
class SandboxController < ApplicationController
  def index
    @snapshots_apac = PI::Snapshot.get_current_snapshots(PI::Snapshot::SOURCE_URL_APAC)
    @snapshots_total = PI::Snapshot.get_current_snapshots(PI::Snapshot::SOURCE_URL_TOTAL)
  end
end
