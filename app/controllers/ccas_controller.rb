class CcasController < ApplicationController
  include CommentableActions
  include FlagActions

  before_action :parse_search_terms, only: :index
  before_action :parse_tag_filter, only: :index
  before_action :authenticate_user!, except: [:index, :show]

  has_orders %w{hot_score confidence_score created_at most_commented random}, only: :index

  load_and_authorize_resource
  respond_to :html, :js

  #def index_customization
  #  #presentación de los ccas destacados
  #  @featured_ccas = Cca.all.sort_by_confidence_score.limit(3) if (@search_terms.blank? && @tag_filter.blank?)
  #  if @featured_ccas.present?
  #    set_featured_cca_votes(@featured_ccas)
  #    @resources = @resources.where('ccas.id NOT IN (?)', @featured_ccas.map(&:id))
  #  end
  #end

  def vote
    @cca.register_vote(current_user, params[:value])
    set_cca_votes(@cca)
  end

  private

    def cca_params
      params.require(:cca).permit(:title, :description, :tag_list, :terms_of_service, :captcha, :captcha_key)
    end

    def resource_model
      Cca
    end

  def set_featured_cca_votes(ccas)
    @featured_ccas_votes = current_user ? current_user.cca_votes(ccas) : {}
    end
end
