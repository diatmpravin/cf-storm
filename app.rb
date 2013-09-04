require File.expand_path('shotgun',  File.dirname(__FILE__))
require File.expand_path("settings", File.dirname(__FILE__))

require 'cuba/render'

Cuba.plugin Cuba::Mote
Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = 'haml'

Cuba.use Rack::Session::Cookie,
  key: '__insert app name__',
  secret: '__insert secret here__'

Cuba.use Rack::Static,
  root: 'public',
  urls: ['/js', '/css', '/less', '/img']

Dir["./models/**/*.rb"].each { |rb| require rb }
Dir["./lib/**/*.rb"].each { |rb| require rb }
Dir["./routes/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::Static,
  root: "public",
  urls: ["/js", "/css", "/img"]

Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.plugin UserHelper

Ohm.connect(url: Settings::REDIS_URL)

Cuba.define do

  on 'favicon.ico' do
  end

  on "sessions" do
    run Sessions
  end

  on "spaces" do |space|
    if current_user
      run Spaces
    else
      res.redirect '/sessions/new'
    end
  end

  # Nothing matched the request address
  on default do
    res.write view('404')
    res.status = 404
  end

end
