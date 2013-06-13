class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #

    user ||= User.new # guest user (not logged in)
    
    can :home, :index
    cannot :google_drive, :read
        
    if [1,2,3].include?(user.activities_access)
      can :read, Activity
      can :index_metro, Activity
      can :show_metro, Activity
#       can :read, Department
      can :confirmer_presence, Registration, :volunteer => Volunteer.where(:email => user.email).first # TODO : faire mieux
    end
    
    if [2,3].include?(user.activities_access)
      can :manage, Activity
      can :manage, Department
    end

    if [1,2,3].include?(user.staff_access)
      can :staff, :index
      can :index_metro, Volunteer
      can :show_metro, Volunteer
      can :read, Volunteer, :email => user.email
      can :read, Training
      can :read, Certificate
      can :read, Department
      cannot :index, Volunteer
    end

    if [2,3].include?(user.staff_access)
      can :read, Volunteer
      can :staff, :volunteers_to_csv # TODO : un à part
      can :staff, :export # TODO : un à part
    end
    
    if [3].include?(user.staff_access)
      can :manage, Volunteer
      can :manage, Certificate
      can :manage, Training
      can :home, :google_drive
      can :google_drive, :dump
      can :google_drive, :write
    end
    
    if [1,2,3].include?(user.equipment_access)
      can :equipment, :index
      can :equipment, :table_items_containers
      can :read, Container
      can :read, Content
      can :read, Item
      can :read, Category
      can :read, Supplier
    end
    
    if [2,3].include?(user.equipment_access)
      can :equipment, :index
      can :manage, Container
      can :manage, Content
      can :manage, Item
      can :manage, Category
      can :manage, Supplier
      can :manage, Purchase
    end    
    
    
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
