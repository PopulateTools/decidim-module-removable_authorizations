# frozen_string_literal: true

module Decidim
  module RemovableAuthorizations
    module Verifications
      module AuthorizeUserOverrides
        def call
          return transfer_authorization if !handler.unique? && handler.transferrable?

          if handler.invalid?
            register_conflict

            return broadcast(:invalid)
          end

          Authorization.create_or_update_from(handler)
          handler.log_successful_authorization

          broadcast(:ok)
        end

        def register_conflict
          conflict = create_verification_conflict
          notify_admins(conflict) if conflict.present?
          handler.log_failed_authorization
        end

        def transfer_authorization_with_log
          handler.log_transfer_authorization
          transfer_authorization
        end
      end
    end
  end
end
