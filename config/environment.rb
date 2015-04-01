# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rails.application.initialize!

Date::DATE_FORMATS[:es] = "%d/%m/%Y"