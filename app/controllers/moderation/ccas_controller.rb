class Moderation::CcasController < Moderation::BaseController
  has_filters %w{pending_flag_review all with_ignored_flag}, only: :index
  has_orders %w{flags created_at}, only: :index

  before_action :load_ccas, only: [:index, :moderate]

  load_and_authorize_resource

  def index
    @ccas = @ccas.send(@current_filter)
                       .send("sort_by_#{@current_order}")
                       .page(params[:page])
                       .per(50)
  end

  def hide
    hide_cca @cca
  end

  def moderate
    @ccas = @ccas.where(id: params[:cca_ids])

    if params[:hide_ccas].present?
      @ccas.accessible_by(current_ability, :hide).each {|cca| hide_cca cca}

    elsif params[:ignore_flags].present?
      @ccas.accessible_by(current_ability, :ignore_flag).each(&:ignore_flag)

    elsif params[:block_authors].present?
      author_ids = @ccas.pluck(:author_id).uniq
      User.where(id: author_ids).accessible_by(current_ability, :block).each {|user| block_user user}
    end

    redirect_to request.query_parameters.merge(action: :index)
  end

  private

    def load_ccas
      @ccas = Cca.accessible_by(current_ability, :moderate)
    end

    def hide_cca(cca)
      cca.hide
      Activity.log(current_user, :hide, cca)
    end

    def block_user(user)
      user.block
      Activity.log(current_user, :block, user)
    end

end
