Rails.application.configure do
  # Other configuration...

  # Allow Heroku host dynamically
  config.hosts << /herokuapp\.com\z/
  # Allow challenges.wynneellis.com
  config.hosts << /challenges.wynneellis.com\z/
end