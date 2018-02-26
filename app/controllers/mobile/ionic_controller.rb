class Mobile::IonicController < ApplicationController

  def google_auth
    require 'uri'
    require 'net/http'
    require 'net/https'

    id_token =  params['id_token']
    params = {:id_token => id_token}
    uri = URI.parse('https://www.googleapis.com/oauth2/v3/tokeninfo')
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)

    if response.code == 200
      data = JSON.parse(response.body)
      puts data
    end

    render :json => data
  end
end
