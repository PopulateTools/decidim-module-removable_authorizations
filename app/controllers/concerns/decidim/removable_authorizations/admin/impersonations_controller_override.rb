# frozen_string_literal: true

module Decidim
  module RemovableAuthorizations
    module Admin
      module ImpersonationsControllerOverride
        extend ActiveSupport::Concern

        included do
          def create
            enforce_permission_to(:impersonate, :impersonatable_user, user:)

            @form = form(Decidim::Admin::ImpersonateUserForm).from_params(
              user:,
              name: params[:impersonate_user][:name],
              handler_name:,
              reason: params[:impersonate_user][:reason],
              authorization: Decidim::AuthorizationHandler.handler_for(
                handler_name,
                params[:impersonate_user][:authorization].merge(user:)
              )
            )

            Decidim::Admin::ImpersonateUser.call(@form) do
              on(:ok) do
                flash[:notice] = I18n.t("impersonations.create.success", scope: "decidim.admin") if creating_managed_user?
                redirect_to decidim.root_path
              end

              on(:invalid) do
                flash.now[:alert] = if @form.authorization.errors[:base].present?
                                      @form.authorization.errors[:base].join("\n")
                                    else
                                      I18n.t("impersonations.create.error", scope: "decidim.admin")
                                    end
                render :new
              end
            end
          end
        end
      end
    end
  end
end
