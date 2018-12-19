# frozen_string_literal: true

# Copyright (c) 2018 FINFEX https://github.com/finfex

require 'bundler/setup'
Bundler.require(:development, :test)
require 'active_support/core_ext/module'
require 'virtus'

require 'payment_services'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
