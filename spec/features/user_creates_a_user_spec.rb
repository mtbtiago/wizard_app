require 'rails_helper'

RSpec.describe 'the user creation success path' do
  context 'when user only clicks next button' do
    it 'creates the user' do
      visit '/'
      click_link 'Create a user'

      # Step 1
      fill_in 'Email', with: 'user@example.com'
      click_button 'Continue'

      # Step 2
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      click_button 'Continue'

      # Step 3
      fill_in 'Address 1', with: 'Bla bla Bla'
      fill_in 'Zip code', with: 'XYZ1234'
      fill_in 'City', with: 'FoobarCity'
      select('France', from: 'Country')
      click_button 'Continue'

      # Step 4
      fill_in 'Phone number', with: '+3366666666'
      click_button 'Finish'

      expect(page).to have_content('User succesfully CREATED!')
    end
  end

  context 'when user clicks next and back buttons' do
    it 'creates the user' do
      visit '/'
      click_link 'Create a user'

      # Step 1
      fill_in 'Email', with: 'user@example.com'
      click_button 'Continue'

      # Step 2
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      click_button 'Continue'

      # back to step 2
      click_link 'Back'
      fill_in 'First name', with: 'FooA'
      fill_in 'Last name', with: 'BarA'
      click_button 'Continue'

      # Step 3
      fill_in 'Address 1', with: 'Bla bla Bla'
      fill_in 'Zip code', with: 'XYZ1234'
      fill_in 'City', with: 'FoobarCity'
      select('France', from: 'Country')
      click_button 'Continue'

      # Step 4
      fill_in 'Phone number', with: '+3366666666'
      click_button 'Finish'

      expect(page).to have_content('User succesfully CREATED!')
      user = User.last
      expect(user.first_name).to eq 'FooA'
      expect(user.last_name).to eq 'BarA'
    end
  end
end
