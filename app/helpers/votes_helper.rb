module VotesHelper

  def debate_percentage_of_likes(debate)
    debate.likes.percent_of(debate.total_votes)
  end

  def cca_percentage_of_likes(cca)
    cca.likes.percent_of(cca.total_votes)
  end

  def medida_percentage_of_likes(medida)
    medida.likes.percent_of(medida.total_votes)
  end

  def law_percentage_of_likes(law)
    law.likes.percent_of(law.total_votes)
  end

  def votes_percentage(vote, debate)
    return "0%" if debate.total_votes == 0
    if vote == 'likes'
      debate_percentage_of_likes(debate).to_s + "%"
    elsif vote == 'dislikes'
      (100 - debate_percentage_of_likes(debate)).to_s + "%"
    end
  end

  def votes_cca_percentage(vote, cca)
    return "0%" if cca.total_votes == 0
    if vote == 'likes'
      cca_percentage_of_likes(cca).to_s + "%"
    elsif vote == 'dislikes'
      (100 - cca_percentage_of_likes(cca)).to_s + "%"
    end
  end

  def votes_medida_percentage(vote, medida)
    return "0%" if medida.total_votes == 0
    if vote == 'likes'
      medida_percentage_of_likes(medida).to_s + "%"
    elsif vote == 'dislikes'
      (100 - medida_percentage_of_likes(medida)).to_s + "%"
    end
  end

  def votes_law_percentage(vote, law)
    return "0%" if law.total_votes == 0
    if vote == 'likes'
      law_percentage_of_likes(law).to_s + "%"
    elsif vote == 'dislikes'
      (100 - law_percentage_of_likes(law)).to_s + "%"
    end
  end

  def css_classes_for_vote(votes, votable)
    case votes[votable.id]
    when true
      {in_favor: "voted", against: "no-voted"}
    when false
      {in_favor: "no-voted", against: "voted"}
    else
      {in_favor: "", against: ""}
    end
  end

  def voted_for?(votes, votable)
    votes[votable.id]
  end

end
