class EnquiriesController < ApplicationController
  include CommentableActions
  include FlagActions

  before_action :parse_search_terms, only: :index
  before_action :parse_tag_filter, only: :index
  before_action :authenticate_user!, except: [:index, :show]

  has_orders %w{hot_score confidence_score created_at most_commented random}, only: :index
  has_orders %w{most_voted newest oldest}, only: :show

  load_and_authorize_resource
  respond_to :html, :js

  def index_customization
    #@featured_enquiries = Enquiry.all.sort_by_confidence_score.limit(3) if (@search_terms.blank? && @tag_filter.blank?)
    @featured_enquiries = Enquiry.where("chosen = true") if (@search_terms.blank? && @tag_filter.blank?)
    if @featured_enquiries.present?
      set_featured_enquiry_votes(@featured_enquiries)
      @resources = @resources.where('enquiries.id NOT IN (?)', @featured_enquiries.map(&:id))
    end
  end

  def vote
    @enquiry.register_vote(current_user, 'yes')
    set_enquiry_votes(@enquiry)
  end

  def vote_featured
    @enquiry.register_vote(current_user, 'yes')
    set_featured_enquiry_votes(@enquiry)
  end

  private

    def enquiry_params
      params.require(:enquiry).permit(:title, :question, :summary, :description, :external_url, :video_url, :responsible_name, :tag_list, :terms_of_service, :captcha, :captcha_key)
    end

    def resource_model
      Enquiry
    end

    def set_featured_enquiry_votes(enquiries)
      @featured_enquiries_votes = current_user ? current_user.enquiry_votes(enquiries) : {}
    end
end
