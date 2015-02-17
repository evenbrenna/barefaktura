class Ability
  include CanCan::Ability

    def initialize(user)
        # Restricts users to managing their own resources. Admins can manage
        # anything. No one will have access to other users resources except
        # for admins through the Active Admin back end interface.
        # This is an extra precaution. Access to the back end is restricted by
        # 'authenticate_active_admin_user!' in application_controller.
        user ||= User.new # guest user (not logged in)
        if user.role? :administrator
            can :manage, :all
        elsif user.role? :user
            can :manage, User, :id => user.id
            can :manage, Invoice, :user_id => user.id
            can :manage, Product, :user_id => user.id
            can :manage, Client, :user_id => user.id
        else
            # Guest users can only see resources that do not implement
            # 'load_and_authorize_resource'. Currently only static_pages_controller
        end
    end
end