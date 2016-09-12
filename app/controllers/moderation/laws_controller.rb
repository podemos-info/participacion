class Moderation::LawsController < Moderation::BaseController
  has_filters %w{pending_flag_review all with_ignored_flag}, only: :index
  has_orders %w{flags created_at}, only: :index

  before_action :load_laws, only: [:index, :moderate]

  load_and_authorize_resource

  def index
    @laws = @laws.send(@current_filter)
                       .send("sort_by_#{@current_order}")
                       .page(params[:page])
                       .per(50)
  end

  def hide
    hide_law @law
  end

  def moderate
    @laws = @laws.where(id: params[:law_ids])

    if params[:hide_laws].present?
      @laws.accessible_by(current_ability, :hide).each {|law| hide_law law}

    elsif params[:ignore_flags].present?
      @laws.accessible_by(current_ability, :ignore_flag).each(&:ignore_flag)

    elsif params[:block_authors].present?
      author_ids = @laws.pluck(:author_id).uniq
      User.where(id: author_ids).accessible_by(current_ability, :block).each {|user| block_user user}
    end

    redirect_to request.query_parameters.merge(action: :index)
  end

  private

    def load_laws
      @laws = Law.accessible_by(current_ability, :moderate)
    end

    def hide_law(law)
      law.hide
      Activity.log(current_user, :hide, law)
    end

    def block_user(user)
      user.block
      Activity.log(current_user, :block, user)
    end

end
