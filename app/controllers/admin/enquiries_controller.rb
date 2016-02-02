class Admin::EnquiriesController < Admin::BaseController
  has_filters %w{without_confirmed_hide all with_confirmed_hide}, only: :index

  before_action :load_enquiry, only: [:confirm_hide, :restore]

  def index
    @enquiries = Enquiry.only_hidden.send(@current_filter).order(hidden_at: :desc).page(params[:page])
  end

  def confirm_hide
    @enquiry.confirm_hide
    redirect_to request.query_parameters.merge(action: :index)
  end

  def restore
    @enquiry.restore
    @enquiry.ignore_flag
    Activity.log(current_user, :restore, @enquiry)
    redirect_to request.query_parameters.merge(action: :index)
  end

  private

    def load_enquiry
      @enquiry = Enquiry.with_hidden.find(params[:id])
    end

end
