class Admin::Enquiry_setsController < Admin::BaseController
  has_filters %w{without_confirmed_hide all with_confirmed_hide}, only: :index

  before_action :load_enquiry_set, only: [:confirm_hide, :restore]

  def index
    @enquiry_set = Enquiry_set.only_hidden.send(@current_filter).order(hidden_at: :desc).page(params[:page])
  end

  def confirm_hide
    @enquiry_set.confirm_hide
    redirect_to request.query_parameters.merge(action: :index)
  end

  def restore
    @enquiry_set.restore
    @enquiry_set.ignore_flag
    Activity.log(current_user, :restore, @enquiry_set)
    redirect_to request.query_parameters.merge(action: :index)
  end

  private

  def load_enquiry_set
      @enquiry_set = Enquiry_set.with_hidden.find(params[:id])
    end

end
