
require 'capybara/rspec'

Capybara.default_driver = :selenium

describe 'Splice user auth', :type => :feature do
  it 'allows a user to create an account and log in and log out' do
    visit 'http://www.splice.com'

    find('.signup-button').click

    random = Random.rand(10**8)
    username = "TestUser#{random}"
    email = "testuser#{random}@mailinator.com"

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'

    expect(find_field('Username')['class']).to match('ng-invalid')

    fill_in 'Username', with: username

    click_on 'Sign Up'

    expect(page).to have_content('Complete your Splice setup')
    expect(page).to have_content('Welcome to Splice!')
    find('.close').click
    find('.js-nav-avatar').click
    click_on 'Log out'
    expect(page).to have_content('Music Made Better')
  end

end
