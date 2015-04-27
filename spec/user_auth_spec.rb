
require 'capybara/rspec'

Capybara.default_driver = :selenium

if ENV['SERVER'] == 'staging'
	Capybara.app_host = "https://staging.splice.com"
else
	Capybara.app_host = "https://splice.com"
end

describe 'Splice user auth', :type => :feature do
  it 'allows a user to create an account and log in and log out' do
    visit '/'

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

  it 'does not allow user to signup without username' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "testuser#{random}@mailinator.com"

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'

    expect(find_field('Username')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup with username less than 3 characters' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "testuser#{random}@mailinator.com"

    fill_in 'Username', with: 'Ja'
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'

    expect(find_field('Username')['class']).to match('ng-invalid')
  end

  it 'yields errors when all fields are left blank' do
    visit '/'

    find('.signup-button').click

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: ''
    fill_in 'Email address', with: ''
    fill_in 'Password', with: ''

    click_on 'Sign Up'

    expect(find_field('Username')['class']).to match('ng-invalid')
    expect(find_field('Artist or Full Name')['class']).to match('ng-invalid')
    expect(find_field('Email address')['class']).to match('ng-invalid')
    expect(find_field('Password')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup without a artist or full name' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    username = "TestUser#{random}"
    email = "testuser#{random}@mailinator.com"

    fill_in 'Username', with: username
    fill_in 'Artist or Full Name', with: ''
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'

    expect(find_field('Artist or Full Name')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup with blank password' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "testuser#{random}@mailinator.com"
    username = "TestUser#{random}"

    fill_in 'Username', with: username
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: ''

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'
    expect(find_field('Password')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup without password of at least 8 characters' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "testuser#{random}@mailinator.com"
    username = "TestUser#{random}"

    fill_in 'Username', with: username
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'pass'

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'
    expect(find_field('Password')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup with non-existant e-mail' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    username = "TestUser#{random}"

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: 'mailinator.com'
    fill_in 'Password', with: 88888888

    expect(find_field('Username')['class']).to match('ng-invalid')

    fill_in 'Username', with: username

    click_on 'Sign Up'
    expect(find_field('Email address')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup with existing e-mail' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "testuser1234567@mailinator.com"
    username = "TestUser#{random}"

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    expect(find_field('Username')['class']).to match('ng-invalid')

    fill_in 'Username', with: username

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'

    expect(find_field('Email address')['class']).to match('ng-invalid')
  end

  it 'does not allow user to signup without accepting the terms of service' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "testuser1234567@mailinator.com"
    username = "TestUser#{random}"

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    expect(find_field('Username')['class']).to match('ng-invalid')

    fill_in 'Username', with: username

    click_on 'Sign Up'

    expect(page).to have_content('Terms must be accepted')
  end

  it 'allows a user to signup with email in all caps' do
    visit '/'

    find('.signup-button').click

    random = Random.rand(10**8)
    email = "TESTUSER#{random}@MAILINATOR.COM"
    username = "TestUser#{random}"

    fill_in 'Username', with: ''
    fill_in 'Artist or Full Name', with: 'Jones'
    fill_in 'Email address', with: email
    fill_in 'Password', with: 'password123'

    check 'I accept Splice\'s Terms of Use and Privacy Policy.'
    click_on 'Sign Up'

    expect(find_field('Username')['class']).to match('ng-invalid')

    fill_in 'Username', with: username

    click_on 'Sign Up'
  end

  # login

  it 'allows user to login to existing account with valid username' do
    visit '/'

    find('a', text: 'Log In').click

    username = "testuser1234567"

    fill_in 'Username or email address', with: username
    fill_in 'Password', with: 'password'

    click_on 'Log In'
    expect(page).to have_content('Dashboard')
  end

  it 'allows user to login to existing account with valid email' do
    visit '/'

    find('a', text: 'Log In').click

    email = "testuser1234567@mailinator.com"

    fill_in 'Username or email address', with: email
    fill_in 'Password', with: 'password'

    click_on 'Log In'
    expect(page).to have_content('Dashboard')
  end

  it 'does not allow user to login with blank username and valid password' do
    visit '/'

    find('a', text: 'Log In').click

    fill_in 'Username or email address', with: ''
    fill_in 'Password', with: 'password'

    click_on 'Log In'
    expect(page). to have_content('This field is required')
  end

  it 'does not allow user to login with valid username and blank password' do
    visit '/'

    find('a', text: 'Log In').click

    fill_in 'Username or email address', with: 'testuser1234567'
    fill_in 'Password', with: ''

    click_on 'Log In'
    expect(page). to have_content('This field is required')
  end

  it 'requires user to fill in both log in fields' do
    visit '/'

    find('a', text: 'Log In').click

    username = "testuser1234567"

    fill_in 'Username or email address', with: ''
    fill_in 'Password', with: ''

    click_on 'Log In'
    expect(page). to have_content('This field is required')

    fill_in 'Username or email address', with: username
    fill_in 'Password', with: 'password'

    click_on 'Log In'
    expect(page).to have_content('Dashboard')
  end



end
