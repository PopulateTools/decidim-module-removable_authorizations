# frozen_string_literal: true

module Decidim
  module RemovableAuthorizations
    module Admin
      # A command with all the business logic to find an authorization by its
      # verification data and delete it.
      #
      class DestroyAuthorization < Decidim::Command
        # Public: Initializes the command.
        #
        # authorization - The authorization
        def initialize(authorization)
          @authorization = authorization
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when the authorization is found and deleted
        # - :not_found if the authorization couldn't be found
        #
        # Returns nothing.
        def call
          return broadcast(:not_found) if authorization.blank?

          destroy_authorization

          broadcast(:ok)
        end

        private

        attr_reader :authorization

        def user
          authorization.user
        end

        def destroy_authorization
          Decidim.traceability.perform_action!("delete", authorization, current_user, extra: { authorization_owner: { id: user.id } }) do
            authorization.destroy
          end
        end
      end
    end
  end
end
