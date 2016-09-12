module MailerHelper

  def commentable_url(commentable)
    return debate_url(commentable) if commentable.is_a?(Debate)
    return medida_url(commentable) if commentable.is_a?(Medida)
    return law_url(commentable) if commentable.is_a?(Law)
    return proposal_url(commentable) if commentable.is_a?(Proposal)
    return enquiry_url(commentable) if commentable.is_a?(Enquiry)
  end

end
