# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

source "https://rubygems.org"
require "decidim/removable_authorizations/version"

ruby RUBY_VERSION
DECIDIM_VERSION = Decidim::RemovableAuthorizations::DECIDIM_VERSION

gem "decidim", DECIDIM_VERSION
gem "decidim-removable_authorizations", path: "."

gem "puma", ">= 6.3.1"
gem "bootsnap", "~> 1.4"
gem "uglifier", "~> 4.1"
gem "deface"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 3.2"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end
