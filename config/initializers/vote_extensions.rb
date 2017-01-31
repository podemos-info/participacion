ActsAsVotable::Vote.class_eval do
  def self.for_debates(debates)
    where(votable_type: 'Debate', votable_id: debates)
  end


   def self.for_ccas(ccas)
    where(votable_type: 'Cca', votable_id: ccas)
  end

  def self.for_medidas(medidas)
    where(votable_type: 'Medida', votable_id: medidas)
  end

  def self.for_laws(laws)
    where(votable_type: 'Law', votable_id: laws)
  end

  def self.for_proposals(proposals)
    where(votable_type: 'Proposal', votable_id: proposals)
  end

  def self.for_enquiries(enquiries)
    where(votable_type: 'Enquiry', votable_id: enquiries)
  end

  def value
    vote_flag
  end
end
