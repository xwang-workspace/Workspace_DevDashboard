
class SandboxController < ApplicationController
  def index
    @snapshots_apac = PI::Snapshot.get_current_snapshots(PI::Snapshot::SOURCE_URL_APAC)
    @statistics_apac = PI::Statistics.new(@snapshots_apac, PI::Team::APACLOCAL)

    @snapshots_global = PI::Snapshot.get_current_snapshots(PI::Snapshot::SOURCE_URL_GLOBAL)
    @statistics_global = PI::Statistics.new(@snapshots_global, PI::Team::GLOBAL)

    @lift_builds = Jenkins::Build.get_builds(Jenkins::PROJECT_LIFT, 12)
    @tank_builds = Jenkins::Build.get_builds(Jenkins::PROJECT_TANK, 12)
    @auth_builds = Jenkins::Build.get_builds(Jenkins::PROJECT_AUTH, 12)
    @arp_builds = Jenkins::Build.get_builds(Jenkins::PROJECT_ARP, 12)
  end
end
