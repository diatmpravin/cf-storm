include UserHelper

prepare do
  Capybara.reset!
end

def login_user!
  visit '/sessions/new'
  within('#new-session') do
    fill_in 'email', with: 'manuel.garcia@altoros.com'
    fill_in 'password', with: '12345678'
  end

  click_button 'Sign in'
end

def assert_app_details app
  assert has_content? app.name
end
