module Decidim
  module RemovableAuthorizations
    module AdminLog
      module UserPresenterOverrides
        NEW_ACTIONS = %w(create_authorization_success create_authorization_error transfer_authorization)

        private

        def action_string
          case action
          when *NEW_ACTIONS
            "decidim.admin_log.user.#{action}"
          else
            super
          end
        end

        def has_diff?
          super || NEW_ACTIONS.include?(action.to_s)
        end

        def show_previous_value_in_diff?
          super && NEW_ACTIONS.exclude?(action.to_s)
        end

        def changeset
          case action
          when *NEW_ACTIONS
            original, fields = authorization_changeset
            Decidim::Log::DiffChangesetCalculator.new(
              original,
              fields,
              i18n_labels_scope
            ).changeset
          else

            super
          end
        end

        def i18n_labels_scope
          case action
          when *NEW_ACTIONS
            "decidim.authorization_handlers.log"
          else
            super
          end
        end

        def authorization_changeset
          changeset_list = action_log.extra.symbolize_keys
            .except(:component, :participatory_space, :resource, :user) # Don't display extra_data added by ActionLogger
            .map { |k, v| [k, [nil, v]] }
          original_changeset = Hash[changeset_list]

          fields_mapping = Hash[original_changeset.map do |k, v|
            [k, authorization_changeset_attribute_type(v.second)]
          end]

          [original_changeset, fields_mapping]
        end

        def authorization_changeset_attribute_type(value)
          [true, false].include?(value) ? :boolean : :string
        end
      end
    end
  end
end
