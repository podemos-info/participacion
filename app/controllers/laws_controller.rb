class LawsController < ApplicationController
  include CommentableActions
  include FlagActions

  before_action :parse_search_terms, only: :index
  before_action :parse_tag_filter, only: :index
  before_action :authenticate_user!, except: [:index, :show]

  has_orders %w{hot_score confidence_score created_at most_commented random}, only: :index

  load_and_authorize_resource
  respond_to :html, :js

  def vote
    @law.register_vote(current_user, params[:value])
    set_law_votes(@law)
  end

  private

    def law_params
      params.require(:law).permit(:title, :description, :tag_list, :terms_of_service, :captcha, :captcha_key)
    end

    def resource_model
      Law
    end

end
