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

    class OmniAuth::Strategies::OAuth2
        # most strategies (Facebook, GoogleOauth2) do not override this method, it means that
        # for such strategies JSON posting of access_token will work out of the box
        def callback_phase_with_json
            # Doing the same thing as Rails controllers do, giving uniform access to GET, POST and JSON params
            # reqest.params contains only GET and POST params as a hash
            # env[..] contains JSON, XML, YAML params as a hash
            # see ActionDispatch::Http::Parameters#parameters
            parsed_params = env['action_dispatch.request.request_parameters']
            if parsed_params
                request.params['code'] = parsed_params['code'] if parsed_params['code']
                request.params['access_token'] = parsed_params['access_token'] if parsed_params['access_token']
                request.params['id_token'] = parsed_params['id_token'] if parsed_params['id_token'] # used by Google
            end
            callback_phase_without_json
        end
        alias_method_chain :callback_phase, :json
    end
end