# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe AuthorizationHandler do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization:) }
    let(:handler) { described_class.new(params) }
    let(:params) { { user:, organization: } }
    let(:action_log) { ActionLog.last }

    describe "log_successful_authorization" do
      before { handler.log_successful_authorization }

      it "creates a log entry" do
        expect(action_log.action).to eq("create_authorization_success")
        expect(action_log.user).to eq(user)
        expect(action_log.resource).to eq(user)

        expect(action_log.extra["handler_name"]).to eq("authorization_handler")
      end
    end

    describe "log_failed_authorization" do
      before { handler.log_failed_authorization }

      it "creates a log entry" do
        expect(action_log.action).to eq("create_authorization_error")
        expect(action_log.user).to eq(user)
        expect(action_log.resource).to eq(user)

        expect(action_log.extra["handler_name"]).to eq("authorization_handler")
      end
    end
  end
end
