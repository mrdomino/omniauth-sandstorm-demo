require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-sandstorm'

main = Rack::Builder.new do

use OmniAuth::Builder do
  provider 'sandstorm'
end

class App < Sinatra::Base
  use Rack::Session::Cookie, secret: 'change_me'

  use OmniAuth::Builder do
    provider :sandstorm
  end

  get '/' do
    <<-HTML
    <ul>
      <li><a href='/auth/sandstorm'>Sign in with Sandstorm</a></li>
    </ul>
    HTML
  end

  get '/auth/:provider/callback' do
    request.env['omniauth.auth'].info.to_hash.inspect
    "<h1>Signed in!</h1>
    <p>Uid:
    <pre>#{request.env['omniauth.auth'].uid}</pre>
    <p>Again:
    <pre>#{request.env['omniauth.auth'].uid}</pre>
    <p>Info:
    <pre>#{request.env['omniauth.auth'].info.to_hash.inspect}</pre>
    <p>Extra:
    <pre>#{request.env['omniauth.auth'].extra.to_hash.inspect}</pre>
    "
  end
end

run App.new

end
