# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/models/decidim/authorization.rb" => "e53b80a3dc1b7b0407a47571fc1e18af",
      "/app/presenters/decidim/admin_log/user_presenter.rb" => "fb3eed1162b4b7a45a106368f5df23ae"
    }
  },
  {
    package: "decidim-verifications",
    files: {
      "/app/commands/decidim/verifications/authorize_user.rb" => "b028cfdbcd137f8e8d62ce4599a4e330",
      "/app/services/decidim/authorization_handler.rb" => "2431258d1323e9224713c42eb5cf32d6"
    }
  },
  {
    package: "decidim-admin",
    files: {
      "/app/controllers/decidim/admin/impersonations_controller.rb" => "226ee2686fea67696191302c2eec31b2"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
