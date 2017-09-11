module Abilities
  class Common
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Everyone.new(user)

      can [:read, :update], User, id: user.id

      can :read, Debate
      can :update, Debate do |debate|
        debate.editable_by?(user)
      end

      can :read, Medida
      can :update, Medida do |medida|
        medida.editable_by?(user)
      end

      can :read, Law
      can :update, Law do |law|
        law.editable_by?(user)
      end

      can :read, Proposal
      can :update, Proposal do |proposal|
        proposal.editable_by?(user)
      end

      can :read, Enquiry
      can :update, Enquiry do |enquiry|
        enquiry.editable_by?(user)
      end

      can :create, Comment
      can :create, Debate
      can :create, Medida
      can :create, Proposal
      can :create, Enquiry

      can [:flag, :unflag], Comment
      cannot [:flag, :unflag], Comment, user_id: user.id

      can [:flag, :unflag], Debate
      cannot [:flag, :unflag], Debate, author_id: user.id

      can [:flag, :unflag], Medida
      cannot [:flag, :unflag], Medida, author_id: user.id

      can [:flag, :unflag], Proposal
      cannot [:flag, :unflag], Proposal, author_id: user.id

      can [:flag, :unflag], Enquiry
      cannot [:flag, :unflag], Enquiry, author_id: user.id

      unless user.organization?
        can :vote, Debate
        can :vote, Medida
        can :vote, Comment
      end

      if user.level_two_or_three_verified?
        can :vote, Proposal
        can :vote_featured, Proposal
        can :vote, Enquiry
        can :vote_featured, Enquiry
      end



    end
  end
end
