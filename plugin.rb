# name: discourse-bekcan-academic-automation
# about: Automation engine for academic badges
# version: 0.1
# authors: Can Bekcan
# url: https://github.com/canbekcan/discourse-bekcan-academic-automation


after_initialize do
  DiscourseEvent.on(:user_updated) do |user|
    # Guard against infinite recursion with delta state checks
    if user.saved_change_to_title? || user.saved_change_to_primary_group_id?
      User.transaction do
        # Enforce atomic badge revocation and group allocation
        AcademicAllocationEngine.enforce_badge_and_group_parity!(user)
      end
    end
  end
end