# frozen_string_literal: true

require "decidim/removable_authorizations/admin"
require "decidim/removable_authorizations/engine"
require "decidim/removable_authorizations/admin_engine"

module Decidim
  # This namespace holds the logic of the `RemovableAuthorizations` component. This component
  # allows users to create removable_authorizations in a participatory space.
  module RemovableAuthorizations
    autoload :AttributeObfuscator, "decidim/removable_authorizations/attribute_obfuscator"
  end
end
