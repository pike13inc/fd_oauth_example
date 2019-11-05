# frozen_string_literal: true

require 'sinatra'
require 'oauth2'
require 'json'
enable :sessions

$consumer_key = ENV['P13_OAUTH_KEY']
$consumer_secret = ENV['P13_OAUTH_SECRET']
$pike13_host = ENV['P13_HOST']

raise 'Set env var P13_HOST to something like http://my-biz.pike13.com' unless $pike13_host
raise 'Must set env var P13_OAUTH_KEY' unless $consumer_key
raise 'Must set env var P13_OAUTH_SECRET' unless $consumer_secret

# Tokens should also work without subdomain
def client
  OAuth2::Client.new($consumer_key, $consumer_secret, site: $pike13_host)
end

get '/' do
  erb :root
end

get '/auth/test' do
  auth_url = client.auth_code.authorize_url(redirect_uri: redirect_uri)
  logger.info "Redirecting the browser to: #{auth_url}"
  redirect auth_url
end

get '/auth/test/callback' do
  auth_code = params['code']
  logger.info "Your auth_code is: #{auth_code}"

  if auth_code.nil?
    @message = 'Authorization request was denied.'
    logger.info @message
    erb :fail
  else
    logger.info 'Will now use the auth_code to retrieve the access_token.'
    access_token = client.auth_code.get_token(auth_code, redirect_uri: redirect_uri)
    session[:access_token] = access_token.token
    logger.info "Access token: #{session[:access_token]}"
    @message = session[:access_token]
    erb :success
  end
end

get '/account' do
  @message = get_response('/api/v2/account.json')
  erb :account
end

def get_response(url)
  access_token = OAuth2::AccessToken.new(client, session[:access_token])
  JSON.parse(access_token.get(url).body)
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/test/callback'
  uri.query = nil
  uri.to_s
end
