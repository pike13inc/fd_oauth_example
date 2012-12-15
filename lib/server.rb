require 'sinatra'
require 'oauth2'
require 'json'
enable :sessions

$consumer_key = ENV['FD_OAUTH_KEY']
$consumer_secret = ENV['FD_OAUTH_SECRET']
$frontdesk_host = ENV['FD_HOST']

raise "Set env var FD_HOST to something like http://my-biz.frontdesk.192.168.1.8.xip.io" unless $frontdesk_host
raise "Must set env var FD_OAUTH_KEY" unless $consumer_key
raise "Must set env var FD_OAUTH_SECRET" unless $consumer_secret

# Tokens should also work without subdomain
def client
  OAuth2::Client.new($consumer_key, $consumer_secret, :site => $frontdesk_host)
end

get "/" do
  erb :root
end

get "/auth/test" do
  redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri)
end

get '/auth/test/callback' do
  access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
  session[:access_token] = access_token.token
  @message = "Successfully authenticated with the server"
  erb :success
end

get '/different' do
  @message = ''
  erb :success
end
get '/another' do
  @message = get_response('/people/me.json')
  erb :another
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