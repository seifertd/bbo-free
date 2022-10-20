ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "faker"
I18n.reload!
require "factory_bot_rails"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add functionality to TestCase
  class ActiveSupport::TestCase
    include FactoryBot::Syntax::Methods
  end
end
