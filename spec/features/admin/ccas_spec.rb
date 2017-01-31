require 'rails_helper'

feature 'Admin ccas' do

  background do
    admin = create(:administrator)
    login_as(admin.user)
  end

  scenario 'Restore' do
    cca = create(:cca, :hidden)
    visit admin_ccas_path

    click_link 'Restore'

    expect(page).to_not have_content(cca.title)

    expect(cca.reload).to_not be_hidden
    expect(cca).to be_ignored_flag
  end

  scenario 'Confirm hide' do
    cca = create(:cca, :hidden)
    visit admin_ccas_path

    click_link 'Confirm'

    expect(page).to_not have_content(cca.title)
    click_link('Confirmed')
    expect(page).to have_content(cca.title)

    expect(cca.reload).to be_confirmed_hide
  end

  scenario "Current filter is properly highlighted" do
    visit admin_ccas_path
    expect(page).to_not have_link('Pending')
    expect(page).to have_link('All')
    expect(page).to have_link('Confirmed')

    visit admin_ccas_path(filter: 'Pending')
    expect(page).to_not have_link('Pending')
    expect(page).to have_link('All')
    expect(page).to have_link('Confirmed')

    visit admin_ccas_path(filter: 'all')
    expect(page).to have_link('Pending')
    expect(page).to_not have_link('All')
    expect(page).to have_link('Confirmed')

    visit admin_ccas_path(filter: 'with_confirmed_hide')
    expect(page).to have_link('All')
    expect(page).to have_link('Pending')
    expect(page).to_not have_link('Confirmed')
  end

  scenario "Filtering ccas" do
    create(:cca, :hidden, title: "Unconfirmed cca")
    create(:cca, :hidden, :with_confirmed_hide, title: "Confirmed cca")

    visit admin_ccas_path(filter: 'pending')
    expect(page).to have_content('Unconfirmed cca')
    expect(page).to_not have_content('Confirmed cca')

    visit admin_ccas_path(filter: 'all')
    expect(page).to have_content('Unconfirmed cca')
    expect(page).to have_content('Confirmed cca')

    visit admin_ccas_path(filter: 'with_confirmed_hide')
    expect(page).to_not have_content('Unconfirmed cca')
    expect(page).to have_content('Confirmed cca')
  end

  scenario "Action links remember the pagination setting and the filter" do
    per_page = Kaminari.config.default_per_page
    (per_page + 2).times { create(:cca, :hidden, :with_confirmed_hide) }

    visit admin_ccas_path(filter: 'with_confirmed_hide', page: 2)

    click_on('Restore', match: :first, exact: true)

    expect(current_url).to include('filter=with_confirmed_hide')
    expect(current_url).to include('page=2')
  end

end
