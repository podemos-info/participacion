module Abilities
  class Moderator
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Moderation.new(user)

      can :comment_as_moderator, [Debate, Medida, Law, Comment, Proposal, Enquiry]
    end
  end
end
