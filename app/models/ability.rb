class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    cannot :manage, :all
    can :manage, User, :id => user.id
    can :manage, Account, :user_id => user.id
    if user.is? :abogado        
        can :manage, UserCausa, :account_id => user.id
        can :manage, Search
        can [:read, :changes, :cortes], GeneralCausa
        
    elsif user.is? :secretaria
        can :manage, User
        can :manage, Account
        can :manage, UserCausa
        can :manage, GeneralCausa
        can :manage, Cliente
        
    elsif user.is? :admin
        can :manage, :all
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
