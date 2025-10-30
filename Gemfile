# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

source "https://rubygems.org"
require "decidim/removable_authorizations/version"

ruby RUBY_VERSION
DECIDIM_VERSION = Decidim::RemovableAuthorizations::DECIDIM_VERSION

gem "decidim", DECIDIM_VERSION
gem "decidim-removable_authorizations", path: "."

gem "bootsnap", require: false
gem "puma", ">= 4.3"
gem "uglifier", "~> 4.1"
gem "deface"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 2.14"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
