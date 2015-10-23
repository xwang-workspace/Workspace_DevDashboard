
class SandboxController < ApplicationController
  def index
    @snapshots_apac = PI::Snapshot.get_current_snapshots(PI::Snapshot::SOURCE_URL_APAC)
    @statistics_apac = PI::Statistics.new(@snapshots_apac, PI::Team::APACLOCAL)

    @snapshots_global = PI::Snapshot.get_current_snapshots(PI::Snapshot::SOURCE_URL_GLOBAL)
    @statistics_global = PI::Statistics.new(@snapshots_global, PI::Team::GLOBAL)

    @builds = Lift::Build.get_builds(12)
  end
end
