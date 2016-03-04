class Enquiry_setController < ApplicationController
  include CommentableActions
  include FlagActions

  before_action :parse_search_terms, only: :index
  before_action :parse_tag_filter, only: :index
  before_action :authenticate_user!, except: [:index, :show]

  load_and_authorize_resource
  respond_to :html, :js

  #def vote
  #  @enquiry.register_vote(current_user, 'yes')
  #  set_enquiry_votes(@enquiry)
  #end

  #def vote_featured
  #  @enquiry.register_vote(current_user, 'yes')
  #  set_featured_enquiry_votes(@enquiry)
  #end

  private

  def enquiry_set_params
    params.require(:enquiry_set).permit(:front_title, :front_text, :button_text, :automatic_redirection, :start_at, :finish_at, :max_chosen_enquiries, :manual_selection, :body_title, :body_text)
    end

    def resource_model
      Enquiry_set
    end

    #def set_featured_enquiry_votes(enquiries)
    #  @featured_enquiries_votes = current_user ? current_user.enquiry_votes(enquiries) : {}
    #end
end
