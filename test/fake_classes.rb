class FakeClient

  Struct.new("Space", :name, :apps)
  Struct.new("App", :name, :state, :memory, :instances, :uris)
  Struct.new("Token", :auth_header, :refresh_token)
  Struct.new("Organization", :name)

  class Struct::App
    def started?
      self.state == 'STARTED'
    end

    def stop!
      self.state = 'STOPPED'
    end

    def start!
      self.state = 'STARTED'
    end
  end

  def login(credentials)
    valid_usernames = ['manuel.garcia@altoros.com']
    if valid_usernames.include? credentials[:username]
      Struct::Token.new "my-auth-token", "my-refresh-token"
    else
      raise CFoundry::Denied
    end
  end

  def organizations
    %w(Acme Lolcat).map do |n|
      Struct::Organization.new n
    end
  end

  def current_organization
    @organization || organizations.first
  end

  def current_organization= org
    @organization = org
  end

  def info
    {:description => "Cloud Foundry sponsored by Pivotal"}
  end

  def self.get(target, token = nil)
    new
  end

  def spaces
    %w(development test production).map do |s|
      Struct::Space.new s, apps
    end
  end

  def apps
    @@_apps ||=
    ["Windows 8", "Win95", "DOS"].map do |a|
      Struct::App.new a, 'STARTED', 128,
       ['LOL INSTANACE', 'LOLOLOL'], ['mswin.run.io']
    end

    @@_apps
  end

end
