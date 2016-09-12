class Admin::LawsController < Admin::BaseController
  has_filters %w{without_confirmed_hide all with_confirmed_hide}, only: :index

  before_action :load_law, only: [:confirm_hide, :restore]

  def index
    @laws = Law.only_hidden.send(@current_filter).order(hidden_at: :desc).page(params[:page])
  end

  def confirm_hide
    @law.confirm_hide
    redirect_to request.query_parameters.merge(action: :index)
  end

  def restore
    @law.restore
    @law.ignore_flag
    Activity.log(current_user, :restore, @law)
    redirect_to request.query_parameters.merge(action: :index)
  end

  private

    def load_law
      @law = Law.with_hidden.find(params[:id])
    end

end
