module Abilities
  class Moderation
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Common.new(user)

      can :read, Organization
      can(:verify, Organization){ |o| !o.verified? }
      can(:reject, Organization){ |o| !o.rejected? }

      can :read, Comment

      can :hide, Comment, hidden_at: nil
      cannot :hide, Comment, user_id: user.id

      can :ignore_flag, Comment, ignored_flag_at: nil, hidden_at: nil
      cannot :ignore_flag, Comment, user_id: user.id

      can :moderate, Comment
      cannot :moderate, Comment, user_id: user.id

      can :hide, Debate, hidden_at: nil
      cannot :hide, Debate, author_id: user.id

      can :ignore_flag, Debate, ignored_flag_at: nil, hidden_at: nil
      cannot :ignore_flag, Debate, author_id: user.id

      can :moderate, Debate
      cannot :moderate, Debate, author_id: user.id

      can :hide, Medida, hidden_at: nil
      cannot :hide, Medida, author_id: user.id

      can :ignore_flag, Medida, ignored_flag_at: nil, hidden_at: nil
      cannot :ignore_flag, Medida, author_id: user.id

      can :moderate, Medida
      cannot :moderate, Medida, author_id: user.id

      can :hide, Law, hidden_at: nil
      cannot :hide, Law, author_id: user.id

      can :ignore_flag, Law, ignored_flag_at: nil, hidden_at: nil
      cannot :ignore_flag, Law, author_id: user.id

      can :moderate, Law
      cannot :moderate, Law, author_id: user.id

      can :hide, Proposal, hidden_at: nil
      cannot :hide, Proposal, author_id: user.id

      can :ignore_flag, Proposal, ignored_flag_at: nil, hidden_at: nil
      cannot :ignore_flag, Proposal, author_id: user.id

      can :moderate, Proposal
      cannot :moderate, Proposal, author_id: user.id

      can :hide, Enquiry, hidden_at: nil
      cannot :hide, Enquiry, author_id: user.id

      can :ignore_flag, Enquiry, ignored_flag_at: nil, hidden_at: nil
      cannot :ignore_flag, Enquiry, author_id: user.id

      can :moderate, Enquiry
      cannot :moderate, Enquiry, author_id: user.id

      can :hide, User
      cannot :hide, User, id: user.id

      can :block, User
      cannot :block, User, id: user.id
    end
  end
end
