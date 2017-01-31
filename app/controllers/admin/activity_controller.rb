class Admin::ActivityController < Admin::BaseController
  has_filters %w{all on_users on_proposals on_debates on_ccas on_medidas on_laws on_comments on_enquiries}

  def show
    @activity = Activity.for_render.send(@current_filter).order(created_at: :desc).page(params[:page])
  end

end
