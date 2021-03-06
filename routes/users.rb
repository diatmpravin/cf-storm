class Users < Cuba

  def update_password_and_set_flash! new, conf, old
    begin
      raise PasswordMissmatch if new != conf
      current_user.change_password new, old
      set_flash! 'Password changed succesfully'
      true
    rescue CFoundry::UAAError => e
      set_flash! e.description, :alert
      false
    rescue PasswordMissmatch => e
      set_flash! e.message, :alert
      false
    end
  end

  def create_user_and_set_flash! email, password
    # TODO Optimize this
    # TODO Add spaces
    # TODO Think what org add when creating
    begin
      new_user = current_user.client.register(email, password)
    rescue CFoundry::UAAError
      set_flash! 'Access denied!', :alert
      return nil
    end

    new_user.add_managed_organization current_organization
    new_user.add_billing_managed_organization current_organization
    new_user.add_audited_organization current_organization
    new_user.organizations = current_organization

    current_user.spaces.each{|s| new_user.add_space s }

    new_user.update!
  end

  define do
    on get, 'profile' do
      @user = current_user
      res.write view('users/profile')
    end

    on get  do
      @users = current_user.current_organization.users

      begin
        @users.first.email unless @users.empty?
        res.write view('users/index')
      rescue CFoundry::UAAError
        set_flash! "You are not allowed visit this section", :alert
        res.redirect root_path
      end
    end

    on post, param('email'), param('password') do |email, password|
      create_user_and_set_flash! email, password
      res.redirect 'users/index'
    end

    on post do
      res.redirect 'users/index'
    end

    on put, param('old_password'), param('password'), param('password_confirmation') do |old_pass, pass, pass_conf|
      if update_password_and_set_flash!(pass, pass_conf, old_pass)
        res.redirect '/session/delete'
      else
        res.redirect 'users/profile'
      end
    end

    on put do
      res.redirect 'users/profile'
    end

    on delete, param('user_guid') do |user_guid|
      user = current_organization.users(:depth => 0).find{|u| u.guid == user_guid}
      if user
        user.delete ? set_flash!('User deleted', :notice) : set_flash!('Something went wrong, try again later', :alert)
      end
      res.redirect users_path
    end

  end
end
