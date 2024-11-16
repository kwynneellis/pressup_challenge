Rails.application.configure do

  # Allow Heroku host dynamically
  config.hosts << /herokuapp\.com\z/
  config.hosts << "challenge-365-c00837f2297c.herokuapp.com"

  # Allow challenges.wynneellis.com
  config.hosts << "challenges.wynneellis.com"
end