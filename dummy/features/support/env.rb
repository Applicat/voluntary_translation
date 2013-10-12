require 'rubygems'
require 'spork'

if ENV['COVERAGE_REPORT']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'cucumber/rails'
require 'factory_girl'
require 'capybara/webkit'
require File.expand_path(File.dirname(__FILE__) + '/../../spec/factories')
require File.expand_path(File.dirname(__FILE__) + '/../../spec/support/mongo_database_cleaner')
require File.join(File.dirname(__FILE__), "integration_sessions_controller")

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

Capybara.javascript_driver = ENV['JAVASCRIPT_DRIVER'] ? ENV['JAVASCRIPT_DRIVER'].to_sym : :webkit

Capybara.add_selector(:row) do
  xpath { |num| ".//tbody/tr[#{num}]" }
end

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :truncation
  Cucumber::Rails::World.use_transactional_fixtures = false
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

After do
  # TODO: find a better solution
  #begin
    MongoDatabaseCleaner.clean
  #rescue Exception => e
  #  DatabaseCleaner.logger.error "Exception encountered by DatabaseCleaner in Cucumber After block: #{e}"
  #end
end


# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as tCucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

