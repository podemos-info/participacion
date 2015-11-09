require "application_responder"

class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  include HasFilters
  include HasOrders

  before_action :authenticate_http_basic, if: :http_basic_auth_site?

  before_action :ensure_signup_complete
  before_action :set_locale
  before_action :track_email_campaign

  check_authorization unless: :devise_controller?
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  layout :set_layout
  respond_to :html

  private

    def authenticate_http_basic
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.application.secrets.http_basic_username && password == Rails.application.secrets.http_basic_password
      end
    end

    def http_basic_auth_site?
      Rails.application.secrets.http_basic_auth
    end

    def verify_lock
      if current_user.locked?
        redirect_to account_path, alert: t('verification.alert.lock')
      end
    end

    def set_locale
      if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
        session[:locale] = params[:locale]
      end

      session[:locale] ||= I18n.default_locale

      I18n.locale = session[:locale]
    end

    def set_layout
      if devise_controller?
        "devise"
      else
        "application"
      end
    end

    def set_debate_votes(debates)
      @debate_votes = current_user ? current_user.debate_votes(debates) : {}
    end

    def set_medida_votes(medidas)
      @medida_votes = current_user ? current_user.medida_votes(medidas) : {}
    end

    def set_proposal_votes(proposals)
      @proposal_votes = current_user ? current_user.proposal_votes(proposals) : {}
    end

    def set_comment_flags(comments)
      @comment_flags = current_user ? current_user.comment_flags(comments) : {}
    end

    def ensure_signup_complete
      # Ensure we don't go into an infinite loop
      return if action_name.in? %w(finish_signup do_finish_signup)

      if user_signed_in? && !current_user.email_provided?
        redirect_to finish_signup_path
      end
    end

    def verify_resident!
      unless current_user.residence_verified?
        redirect_to new_residence_path, alert: t('verification.residence.alert.unconfirmed_residency')
      end
    end

    def verify_verified!
      if current_user.level_three_verified?
        redirect_to(account_path, notice: t('verification.redirect_notices.already_verified'))
      end
    end

    def track_email_campaign
      if params[:track_id]
        campaign = Campaign.where(track_id: params[:track_id]).first
        ahoy.track campaign.name if campaign.present?
      end
    end
end
