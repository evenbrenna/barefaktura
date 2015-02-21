class Ability
  include CanCan::Ability

  # Restricts users to managing their own resources. Admins can manage
  # anything. No one will have access to other users resources except
  # for admins through the Active Admin back end interface.
  # This is an extra precaution. Access to the back end is restricted by
  # 'authenticate_active_admin_user!' in application_controller.
  def initialize(user)
    user ||= User.new

    if user.role? :administrator
      can :manage, :all
    else
      can :manage, User,    :id      => user.id
      can :manage, Invoice, :user_id => user.id
      can :manage, Product, :user_id => user.id
      can :manage, Client,  :user_id => user.id
    end
  end
end
