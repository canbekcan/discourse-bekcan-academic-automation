after_initialize do
  DiscourseEvent.on(:user_updated) do |user|
    # Apply x04d rule: Rigorous attribute delta state checks to break recursive stack overflow cycles
    if user.saved_change_to_title? || user.saved_change_to_primary_group_id?
      User.transaction do
        # Atomic execution of badge revocation and group allocation
        AcademicAllocationEngine.enforce_badge_and_group_parity!(user)
      end
    end
  end
end