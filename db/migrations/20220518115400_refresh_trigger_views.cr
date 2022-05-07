class RefreshTriggerViews::V20220518115400 < Avram::Migrator::Migration::V1
  def migrate
    TriggerToken.refresh
  end

  def rollback
  end
end
