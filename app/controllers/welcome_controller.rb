class WelcomeController < ApplicationController
  skip_authorization_check

  layout "devise", only: :welcome

  def index
    if current_user
      redirect_to :highlights
    end
  end

  def welcome
  end

  def highlights
    debates = Debate.sort_by_hot_score.page(params[:page]).per(10).for_render
    set_debate_votes(debates)

    medidas = Medida.sort_by_hot_score.page(params[:page]).per(10).for_render
    set_medida_votes(medidas)

    proposals = Proposal.sort_by_hot_score.page(params[:page]).per(10).for_render
    set_proposal_votes(proposals)

    enquiries = Enquiry.sort_by_hot_score.page(params[:page]).per(10).for_render
    set_enquiry_votes(enquiries)

    @list = (debates.to_a + proposals.to_a).sort{|a, b| b.hot_score <=> a.hot_score}
    @paginator = debates.total_pages > proposals.total_pages ? debates : proposals

    render 'highlights'
  end

end
