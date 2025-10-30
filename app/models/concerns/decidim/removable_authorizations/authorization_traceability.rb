# frozen_string_literal: true

module Decidim
  module RemovableAuthorizations
    module AuthorizationTraceability
      extend ActiveSupport::Concern

      included do
        include Decidim::Traceable
        include Decidim::Loggable
      end
    end
  end
end
