require 'rails_helper'
include ActionView::Helpers::DateHelper

feature 'Commenting debates' do
  let(:user)   { create :user }
  let(:debate) { create :debate }

  scenario 'Index' do
    3.times { create(:comment, commentable: debate) }

    visit debate_path(debate)

    expect(page).to have_css('.comment', count: 3)

    comment = Comment.last
    within first('.comment') do
      expect(page).to have_content comment.user.name
      expect(page).to have_content I18n.l(comment.created_at, format: :datetime)
      expect(page).to have_content comment.body
    end
  end

  scenario 'Comment order' do
    c1 = create(:comment, :with_confidence_score, commentable: debate, cached_votes_up: 100, cached_votes_total: 120, created_at: Time.now - 2)
    c2 = create(:comment, :with_confidence_score, commentable: debate, cached_votes_up: 10, cached_votes_total: 12, created_at: Time.now - 1)
    c3 = create(:comment, :with_confidence_score, commentable: debate, cached_votes_up: 1, cached_votes_total: 2, created_at: Time.now)

    visit debate_path(debate, order: :most_voted)

    expect(c1.body).to appear_before(c2.body)
    expect(c2.body).to appear_before(c3.body)

    visit debate_path(debate, order: :newest)

    expect(c3.body).to appear_before(c2.body)
    expect(c2.body).to appear_before(c1.body)

    visit debate_path(debate, order: :oldest)

    expect(c1.body).to appear_before(c2.body)
    expect(c2.body).to appear_before(c3.body)
  end

  scenario 'Creation date works differently in roots and in child comments, even when sorting by confidence_score' do
    old_root = create(:comment, commentable: debate, created_at: Time.now - 10)
    new_root = create(:comment, commentable: debate, created_at: Time.now)
    old_child = create(:comment, commentable: debate, parent_id: new_root.id, created_at: Time.now - 10)
    new_child = create(:comment, commentable: debate, parent_id: new_root.id, created_at: Time.now)

    visit debate_path(debate, order: :most_voted)

    expect(new_root.body).to appear_before(old_root.body)
    expect(old_child.body).to appear_before(new_child.body)

    visit debate_path(debate, order: :newest)

    expect(new_root.body).to appear_before(old_root.body)
    expect(new_child.body).to appear_before(old_child.body)

    visit debate_path(debate, order: :oldest)

    expect(old_root.body).to appear_before(new_root.body)
    expect(old_child.body).to appear_before(new_child.body)
  end

  scenario 'Turns links into html links' do
    create :comment, commentable: debate, body: 'Built with http://rubyonrails.org/'

    visit debate_path(debate)

    within first('.comment') do
      expect(page).to have_content 'Built with http://rubyonrails.org/'
      expect(page).to have_link('http://rubyonrails.org/', href: 'http://rubyonrails.org/')
      expect(find_link('http://rubyonrails.org/')[:rel]).to eq('nofollow')
      expect(find_link('http://rubyonrails.org/')[:target]).to eq('_blank')
    end
  end

  scenario 'Sanitizes comment body for security' do
    create :comment, commentable: debate, body: "<script>alert('hola')</script> <a href=\"javascript:alert('sorpresa!')\">click me<a/> http://madrid.es"

    visit debate_path(debate)

    within first('.comment') do
      expect(page).to have_content "click me http://madrid.es"
      expect(page).to have_link('http://madrid.es', href: 'http://madrid.es')
      expect(page).not_to have_link('click me')
    end
  end

  scenario 'Paginated comments' do
    per_page = 10
    (per_page + 2).times { create(:comment, commentable: debate)}

    visit debate_path(debate)

    expect(page).to have_css('.comment', count: per_page)
    within("ul.pagination") do
      expect(page).to have_content("1")
      expect(page).to have_content("2")
      expect(page).to_not have_content("3")
      click_link "Next", exact: false
    end

    expect(page).to have_css('.comment', count: 2)
  end

  feature 'Not logged user' do
    scenario 'can not see comments forms' do
      create(:comment, commentable: debate)
      visit debate_path(debate)

      expect(page).to have_content 'You need to sign in or sign up to comment'
      within('#comments') do
        expect(page).to_not have_content 'Write a comment'
        expect(page).to_not have_content 'Reply'
        expect(page).to_not have_css('form')
      end
    end
  end

  scenario 'Create', :js do
    login_as(user)
    visit debate_path(debate)

    fill_in "comment-body-debate_#{debate.id}", with: 'Have you thought about...?'
    click_button 'Publish comment'

    within "#comments" do
      expect(page).to have_content 'Have you thought about...?'
    end
  end

  scenario 'Errors on create', :js do
    login_as(user)
    visit debate_path(debate)

    click_button 'Publish comment'

    expect(page).to have_content "Can't be blank"
  end

  scenario 'Reply', :js do
    citizen = create(:user, username: 'Ana')
    manuela = create(:user, username: 'Manuela')
    comment = create(:comment, commentable: debate, user: citizen)

    login_as(manuela)
    visit debate_path(debate)

    click_link "Reply"

    within "#js-comment-form-comment_#{comment.id}" do
      fill_in "comment-body-comment_#{comment.id}", with: 'It will be done next week.'
      click_button 'Publish reply'
    end

    within "#comment_#{comment.id}" do
      expect(page).to have_content 'It will be done next week.'
    end

    expect(page).to_not have_selector("#js-comment-form-comment_#{comment.id}", visible: true)
  end

  scenario 'Errors on reply', :js do
    comment = create(:comment, commentable: debate, user: user)

    login_as(user)
    visit debate_path(debate)

    click_link "Reply"

    within "#js-comment-form-comment_#{comment.id}" do
      click_button 'Publish reply'
      expect(page).to have_content "Can't be blank"
    end

  end

  scenario "N replies", :js do
    parent = create(:comment, commentable: debate)

    7.times do
      create(:comment, commentable: debate, parent: parent)
      parent = parent.children.first
    end

    visit debate_path(debate)
    expect(page).to have_css(".comment.comment.comment.comment.comment.comment.comment.comment")
  end

  scenario "Flagging as inappropriate", :js do
    comment = create(:comment, commentable: debate)

    login_as(user)
    visit debate_path(debate)

    within "#comment_#{comment.id}" do
      page.find("#flag-expand-comment-#{comment.id}").click
      page.find("#flag-comment-#{comment.id}").click

      expect(page).to have_css("#unflag-expand-comment-#{comment.id}")
    end

    expect(Flag.flagged?(user, comment)).to be
  end

  scenario "Undoing flagging as inappropriate", :js do
    comment = create(:comment, commentable: debate)
    Flag.flag(user, comment)

    login_as(user)
    visit debate_path(debate)

    within "#comment_#{comment.id}" do
      page.find("#unflag-expand-comment-#{comment.id}").click
      page.find("#unflag-comment-#{comment.id}").click

      expect(page).to have_css("#flag-expand-comment-#{comment.id}")
    end

    expect(Flag.flagged?(user, comment)).to_not be
  end

  scenario "Flagging turbolinks sanity check", :js do
    debate = create(:debate, title: "Should we change the world?")
    comment = create(:comment, commentable: debate)

    login_as(user)
    visit debates_path
    click_link "Should we change the world?"

    within "#comment_#{comment.id}" do
      page.find("#flag-expand-comment-#{comment.id}").click
      expect(page).to have_selector("#flag-comment-#{comment.id}")
    end
  end

  feature "Moderators" do
    scenario "can create comment as a moderator", :js do
      moderator = create(:moderator)

      login_as(moderator.user)
      visit debate_path(debate)

      fill_in "comment-body-debate_#{debate.id}", with: "I am moderating!"
      check "comment-as-moderator-debate_#{debate.id}"
      click_button "Publish comment"

      within "#comments" do
        expect(page).to have_content "I am moderating!"
        expect(page).to have_content "Moderator ##{moderator.id}"
        expect(page).to have_css "p.is-moderator"
        expect(page).to have_css "img.moderator-avatar"
      end
    end

    scenario "can create reply as a moderator", :js do
      citizen = create(:user, username: "Ana")
      manuela = create(:user, username: "Manuela")
      moderator = create(:moderator, user: manuela)
      comment = create(:comment, commentable: debate, user: citizen)

      login_as(manuela)
      visit debate_path(debate)

      click_link "Reply"

      within "#js-comment-form-comment_#{comment.id}" do
        fill_in "comment-body-comment_#{comment.id}", with: "I am moderating!"
        check "comment-as-moderator-comment_#{comment.id}"
        click_button 'Publish reply'
      end

      within "#comment_#{comment.id}" do
        expect(page).to have_content "I am moderating!"
        expect(page).to have_content "Moderator ##{moderator.id}"
        expect(page).to have_css "p.is-moderator"
        expect(page).to have_css "img.moderator-avatar"
      end

      expect(page).to_not have_selector("#js-comment-form-comment_#{comment.id}", visible: true)
    end

    scenario "can not comment as an administrator" do
      moderator = create(:moderator)

      login_as(moderator.user)
      visit debate_path(debate)

      expect(page).to_not have_content "Comment as administrator"
    end
  end

  feature "Administrators" do
    scenario "can create comment as an administrator", :js do
      admin = create(:administrator)

      login_as(admin.user)
      visit debate_path(debate)

      fill_in "comment-body-debate_#{debate.id}", with: "I am your Admin!"
      check "comment-as-administrator-debate_#{debate.id}"
      click_button "Publish comment"

      within "#comments" do
        expect(page).to have_content "I am your Admin!"
        expect(page).to have_content "Administrator ##{admin.id}"
        expect(page).to have_css "p.is-admin"
        expect(page).to have_css "img.admin-avatar"
      end
    end

    scenario "can create reply as an administrator", :js do
      citizen = create(:user, username: "Ana")
      manuela = create(:user, username: "Manuela")
      admin   = create(:administrator, user: manuela)
      comment = create(:comment, commentable: debate, user: citizen)

      login_as(manuela)
      visit debate_path(debate)

      click_link "Reply"

      within "#js-comment-form-comment_#{comment.id}" do
        fill_in "comment-body-comment_#{comment.id}", with: "Top of the world!"
        check "comment-as-administrator-comment_#{comment.id}"
        click_button 'Publish reply'
      end

      within "#comment_#{comment.id}" do
        expect(page).to have_content "Top of the world!"
        expect(page).to have_content "Administrator ##{admin.id}"
        expect(page).to have_css "p.is-admin"
        expect(page).to have_css "img.admin-avatar"
      end

      expect(page).to_not have_selector("#js-comment-form-comment_#{comment.id}", visible: true)
    end

    scenario "can not comment as a moderator" do
      admin  = create(:administrator)

      login_as(admin.user)
      visit debate_path(debate)

      expect(page).to_not have_content "Comment as moderator"
    end
  end

  feature 'Voting comments' do
    background do
      @manuela = create(:user, verified_at: Time.now)
      @pablo = create(:user)
      @debate = create(:debate)
      @comment = create(:comment, commentable: @debate)

      login_as(@manuela)
    end

    scenario 'Show' do
      create(:vote, voter: @manuela, votable: @comment, vote_flag: true)
      create(:vote, voter: @pablo, votable: @comment, vote_flag: false)

      visit debate_path(@debate)

      within("#comment_#{@comment.id}_votes") do
        within(".in_favor") do
          expect(page).to have_content "1"
        end

        within(".against") do
          expect(page).to have_content "1"
        end

        expect(page).to have_content "2 votes"
      end
    end

    scenario 'Create', :js do
      visit debate_path(@debate)

      within("#comment_#{@comment.id}_votes") do
        find(".in_favor a").click

        within(".in_favor") do
          expect(page).to have_content "1"
        end

        within(".against") do
          expect(page).to have_content "0"
        end

        expect(page).to have_content "1 vote"
      end
    end

    scenario 'Update', :js do
      visit debate_path(@debate)

      within("#comment_#{@comment.id}_votes") do
        find('.in_favor a').click
        find('.against a').click

        within('.in_favor') do
          expect(page).to have_content "0"
        end

        within('.against') do
          expect(page).to have_content "1"
        end

        expect(page).to have_content "1 vote"
      end
    end

    scenario 'Trying to vote multiple times', :js do
      visit debate_path(@debate)

      within("#comment_#{@comment.id}_votes") do
        find('.in_favor a').click
        find('.in_favor a').click

        within('.in_favor') do
          expect(page).to have_content "1"
        end

        within('.against') do
          expect(page).to have_content "0"
        end

        expect(page).to have_content "1 vote"
      end
    end
  end

end
