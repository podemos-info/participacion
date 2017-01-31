module Abilities
  class Everyone
    include CanCan::Ability

    def initialize(user)
      can :read, Debate
      can :read, Cca
      can :read, Medida
      can :read, Law
      can :read, Proposal
      can :read, Enquiry
    end
  end
end
