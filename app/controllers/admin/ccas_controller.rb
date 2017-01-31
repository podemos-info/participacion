class Admin::CcasController < Admin::BaseController
  has_filters %w{without_confirmed_hide all with_confirmed_hide}, only: :index

  before_action :load_cca, only: [:confirm_hide, :restore]

  def index
    @ccas = Cca.only_hidden.send(@current_filter).order(hidden_at: :desc).page(params[:page])
  end

  def confirm_hide
    @cca.confirm_hide
    redirect_to request.query_parameters.merge(action: :index)
  end

  def restore
    @cca.restore
    @cca.ignore_flag
    Activity.log(current_user, :restore, @cca)
    redirect_to request.query_parameters.merge(action: :index)
  end

  private

    def load_cca
      @cca = Cca.with_hidden.find(params[:id])
    end

end
