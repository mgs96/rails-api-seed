Devise.setup do |config|
    config.navigational_formats = []
    config.mailer_sender = "mauricio.guzman.salazar@gmail.com"
    config.omniauth :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], {:provider_ignores_state => true}
end

Rails.application.config.to_prepare do              # to_prepare ensures that the monkey patching happens before the first request
    Devise::OmniauthCallbacksController.class_eval do # reopen the class
        def failure                                     # redefine the failure method
        set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
        redirect_to after_omniauth_failure_path_for(resource_name)
        end
    end

    module OmniAuth
        module Strategies
            class GoogleOauth2
                def get_access_token(request)
                json = JSON.parse(request.body.read)
                json = json.dup.deep_transform_keys { |key| key.to_s.underscore }
                raise "invalid token '#{json['access_token']}'" unless verify_token(json['access_token'])
                ::OAuth2::AccessToken.from_hash(client, json)
                end
            end
        end
    end
end