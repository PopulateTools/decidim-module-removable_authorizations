module Decidim
  module RemovableAuthorizations
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          if user.admin?
            allow! if permission_action.subject == :authorizations
          end

          permission_action
        end
      end
    end
  end
end
