# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe DummyAuthorizationHandler do
    let(:handler) { described_class.new(params.merge(extra_params)) }
    let(:params) { { user: create(:user, :confirmed) } }
    let(:extra_params) { {} }

    describe "logging" do
      let(:logged_attributes) { ActionLog.last.extra }
      let(:extra_params) { { document_number: "12345678X" } }

      before { handler.log_successful_authorization }

      it "logs inherited attributes" do
        expect(logged_attributes["handler_name"]).to eq("dummy_authorization_handler")
      end

      it "logs obfuscated custom attributes" do
        expect(logged_attributes["document_number"]).to eq("1*******X")
      end
    end
  end
end
