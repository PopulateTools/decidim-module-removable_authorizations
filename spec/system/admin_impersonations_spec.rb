# frozen_string_literal: true

require "spec_helper"

describe "Admin manages impersonations", with_authorization_workflows: ["dummy_authorization_handler"] do
  let(:organization) { create(:organization, available_authorizations: ["dummy_authorization_handler"]) }
  let(:admin) { create(:user, :admin, :confirmed, organization:) }
  let(:document_number) { "123456789X" }
  let(:birthday) { "12" }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user
    visit decidim_admin.root_path
    click_on "Participants"
    within_admin_sidebar_menu do
      click_on "Impersonations"
    end
  end

  context "when trying to impersonate a new user with existing authorization data" do
    context "when the existing user is a managed user" do
      let(:existing_user) { create(:user, :confirmed, organization:, managed: true, name: "Managed User Name") }
      let!(:existing_authorization) do
        create(:authorization, user: existing_user, unique_id: document_number, name: "dummy_authorization_handler")
      end

      it "displays an error message indicating the user is managed" do
        click_on "Manage new participant"

        fill_in "Reason", with: "Test"
        fill_in "Name", with: "New User"
        fill_in "Document number", with: document_number

        click_on "Impersonate"

        expect(page).to have_content("You are managing the participant Managed User Name")
      end
    end

    context "when the existing user is a managed user but the authorization is not available" do
      # This may happen if at the moment of validating the authorization data
      # an attribute required to build the unique_id is missing
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Decidim::AuthorizationHandler).to receive(:duplicate).and_return(existing_authorization)
        # rubocop:enable RSpec/AnyInstance
      end

      let(:existing_user) { create(:user, :confirmed, organization:, managed: true, name: "Managed User Name") }
      let!(:existing_authorization) do
        create(:authorization, user: existing_user, unique_id: document_number, name: "dummy_authorization_handler")
      end

      it "displays an error message indicating the user is managed" do
        click_on "Manage new participant"

        fill_in "Reason", with: "Test"
        fill_in "Name", with: "New User"
        fill_in "Document number", with: document_number

        click_on "Impersonate"

        expect(page).to have_content("A user has already been verified with this identification document")
        expect(page).to have_content("It is associated with a managed account")
        expect(page).to have_content("Contact an administrator to promote the original account")
      end
    end

    context "when the existing user is a regular user" do
      let(:existing_user) { create(:user, :confirmed, organization:, email: "existing@example.com") }
      let!(:existing_authorization) do
        create(:authorization, user: existing_user, unique_id: document_number, name: "dummy_authorization_handler")
      end

      it "displays an error message indicating the user is regular" do
        click_on "Manage new participant"

        fill_in "Reason", with: "Test"
        fill_in "Name", with: "New User"
        fill_in "Document number", with: document_number

        click_on "Impersonate"

        expect(page).to have_content("A user has already been verified with this identification document")
        expect(page).to have_content("It is associated to the account with email")
        expect(page).to have_content("Try to login with that account")
      end
    end
  end
end
