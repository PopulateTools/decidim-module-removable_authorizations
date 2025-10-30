# frozen_string_literal: true

module Decidim
  module RemovableAuthorizations
    module Admin
      # Controller that allows searching and destroy authorizations by passing
      # the user verification data used to generate the authorization
      #
      class AuthorizationsController < Decidim::RemovableAuthorizations::Admin::ApplicationController
        layout "decidim/admin/users"

        helper_method :available_authorization_handlers, :other_available_authorizations

        def index
          enforce_permission_to :index, :authorizations

          @form = form(AuthorizationForm).from_params(
            handler_name:,
            authorization: Decidim::AuthorizationHandler.handler_for(
              handler_name,
              user:
            )
          )
        end

        def search
          @authorization = Authorization.find_by(unique_id: authorization_form.authorization.unique_id)
          @encrypted_id = @authorization.presence && encrypt_id(@authorization.id)
          @form = authorization_form

          render :index
        end

        def destroy
          enforce_permission_to :delete, :authorizations

          id = decrypt_id(params[:id])
          authorization = Authorization.find_by(id:)

          DestroyAuthorization.call(authorization) do
            on(:ok) do
              flash[:notice] = I18n.t("authorizations.delete.success", scope: "decidim.removable_authorizations.admin")
              redirect_to authorizations_path
            end

            on(:not_found) do
              flash[:alert] = I18n.t("authorizations.delete.not_found", scope: "decidim.removable_authorizations.admin")
              redirect_to authorizations_path
            end
          end
        end

        private

        def decrypt_id(encrypted_id)
          Decidim::AttributeEncryptor.decrypt(Base64.urlsafe_decode64(encrypted_id))
        rescue ArgumentError, ActiveSupport::MessageEncryptor::InvalidMessage
          nil
        end

        def encrypt_id(id)
          Base64.urlsafe_encode64(Decidim::AttributeEncryptor.encrypt(id))
        end

        def authorization_form
          @authorization_form ||= form(AuthorizationForm).from_params(
            handler_name:,
            authorization: Decidim::AuthorizationHandler.handler_for(
              handler_name,
              params[:authorization][:authorization].merge(user:)
            )
          )
        end

        def user
          @user ||= Decidim::User.new(
            organization: current_organization,
            admin: false,
            managed: true
          )
        end

        def handler_name
          authorization = params.dig(:authorization, :authorization)
          return available_authorization_handlers.first.name unless authorization

          authorization[:handler_name]
        end

        def other_available_authorizations
          return [] if available_authorization_handlers.size == 1

          other_available_authorization_handlers.map do |authorization_handler|
            Decidim::AuthorizationHandler.handler_for(authorization_handler.name)
          end
        end

        def other_available_authorization_handlers
          Decidim::Verifications::Adapter.from_collection(
            current_organization.available_authorization_handlers - [handler_name]
          )
        end

        def available_authorization_handlers
          Decidim::Verifications::Adapter.from_collection(
            current_organization.available_authorization_handlers
          )
        end
      end
    end
  end
end
