Devise.setup do |config|
    config.navigational_formats = []
    config.mailer_sender = "mauricio.guzman.salazar@gmail.com"
    config.omniauth :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], {}
end