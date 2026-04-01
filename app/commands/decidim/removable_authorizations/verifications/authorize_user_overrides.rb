# frozen_string_literal: true

module Decidim
  module RemovableAuthorizations
    module Verifications
      module AuthorizeUserOverrides
        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the handler was not valid and we could not proceed.
        # - :transferred if there is a duplicated authorization associated
        #                to other user and the authorization can be
        #                transferred.
        # - :transfer_user if there is a duplicated authorization associated
        #                  to an ephemeral user and the current user is also
        #                  ephemeral the session is transferred to the user
        #                  with the existing authorization
        #
        # Returns nothing.
        def call
          if !handler.unique? && handler.user_transferrable?
            handler.user = handler.duplicate.user
            Authorization.create_or_update_from(handler)
            return broadcast(:transfer_user, handler.user)
          end

          return transfer_authorization_with_log if !handler.unique? && handler.transferrable?

          if handler.invalid?
            register_conflict

            return broadcast(:invalid)
          end

          return broadcast(:invalid) unless set_tos_agreement

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
