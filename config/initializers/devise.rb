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
                    puts "COLETO----------------------------------------------------------------------------------------"
                    puts json['access_token']
                    puts "COLETO----------------------------------------------------------------------------------------"
                    json = json.dup.deep_transform_keys { |key| key.to_s.underscore }
                    raise "invalid token '#{json['access_token']}'" unless verify_token(json['access_token'])
                        ::OAuth2::AccessToken.from_hash(client, json)
                    end
                end

                def verify_token(access_token)
                    return false unless access_token
                    raw_response = client.request(:get, 'https://www.googleapis.com/oauth2/v3/tokeninfo',
                                                  params: { access_token: access_token }).parsed
                    raw_response['aud'] == options.client_id || options.authorized_client_ids.include?(raw_response['aud'])
                  end
            end
        end

    # module OmniAuth
    #     module Strategies
    #         class GoogleOauth2
    #             def get_access_token(request)
    #                 puts "COLETO----------------------------------------------------------------------------------------"
    #                 puts request.params.inspect
    #                 puts request.xhr?
    #                 puts "COLETO----------------------------------------------------------------------------------------"
    #                 if request.xhr? && request.params['code']
    #                   verifier = request.params['code']
    #                   redirect_uri = request.params['redirect_uri'] || 'postmessage'
    #                   client.auth_code.get_token(verifier, get_token_options(redirect_uri), deep_symbolize(options.auth_token_params || {}))
    #                 elsif request.params['code'] && request.params['redirect_uri']
    #                   verifier = request.params['code']
    #                   redirect_uri = request.params['redirect_uri']
    #                   client.auth_code.get_token(verifier, get_token_options(redirect_uri), deep_symbolize(options.auth_token_params || {}))
    #                 elsif verify_token(request.params['access_token'])
    #                   ::OAuth2::AccessToken.from_hash(client, request.params.dup)
    #                 else
    #                   verifier = request.params['code']
    #                   client.auth_code.get_token(verifier, get_token_options(callback_url), deep_symbolize(options.auth_token_params))
    #                 end
    #               end
    #         end
    #     end
    # end

    
end