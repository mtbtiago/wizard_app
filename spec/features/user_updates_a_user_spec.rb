require 'rails_helper'

RSpec.describe 'the user update success path' do
  before do
    User.create!(
    first_name: 'uno',
    last_name: 'dos',
    email: 'a@a.com',
    address_1: 'blah',
    zip_code: 'blah',
    city: 'blah',
    country: 'AU',
    phone_number: 'blah'
    )
  end

  context 'when user only clicks next button' do
    it 'updates the user' do
      visit '/'
      click_link 'Edit last user'

      # Step 1
      expect(find(:css, '#user_wizard_email').value).to have_content('a@a.com')
      click_button 'Continue'

      # Step 2
      expect(find(:css, '#user_wizard_last_name').value).to have_content('dos')
      click_button 'Continue'

      # Step 3
      expect(find(:css, '#user_wizard_zip_code').value).to have_content('blah')
      click_button 'Continue'

      # Step 4
      expect(find(:css, '#user_wizard_phone_number').value).to have_content('blah')
      click_button 'Finish'

      expect(page).to have_content('User succesfully UPDATED!')
    end
  end

  context 'when user makes changes' do
    it 'updates the user' do
      visit '/'
      click_link 'Edit last user'

      # Step 1
      click_button 'Continue'

      # Step 2
      fill_in 'First name', with: 'changed'
      click_button 'Continue'

      # Step 3
      click_button 'Continue'

      # Step 4
      click_button 'Finish'

      expect(page).to have_content('User succesfully UPDATED!')
      user = User.last
      expect(user.first_name).to eq 'changed'
    end
  end
end
