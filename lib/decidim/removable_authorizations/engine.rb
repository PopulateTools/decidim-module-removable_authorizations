# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module RemovableAuthorizations
    # This is the engine that runs on the public interface of removable_authorizations.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::RemovableAuthorizations

      routes do
        # Add engine routes here
        # resources :removable_authorizations
        # root to: "removable_authorizations#index"
      end

      initializer "decidim_removable_authorizations.decidim_additions" do
        config.to_prepare do
          Decidim::Authorization.class_eval do
            include Decidim::RemovableAuthorizations::AuthorizationTraceability

            def self.log_presenter_class_for(_log)
              Decidim::RemovableAuthorizations::AdminLog::AuthorizationPresenter
            end
          end

          Decidim::Verifications::AuthorizeUser.class_eval do
            prepend Decidim::RemovableAuthorizations::Verifications::AuthorizeUserOverrides
          end

          Decidim::AuthorizationHandler.class_eval do
            prepend Decidim::RemovableAuthorizations::AuthorizationHandlerOverrides
          end

          Decidim::AdminLog::UserPresenter.class_eval do
            prepend Decidim::RemovableAuthorizations::AdminLog::UserPresenterOverrides
          end

          Decidim::Admin::ImpersonationsController.include(
            Decidim::RemovableAuthorizations::Admin::ImpersonationsControllerOverride
          )
        end
      end
    end
  end
end
