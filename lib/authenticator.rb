module Authenticator
  class AdminConstraint
    def matches?(request)
      session = Session.find_by_id(request.cookie_jar.signed[:session_token])

      if session
        session.user.admin?
      else
        false
      end
    end
  end

  class UserConstraint
    def matches?(request)
      session = Session.find_by_id(request.cookie_jar.signed[:session_token])

      if session
        session.user
      else
        false
      end
    end
  end

  class ForbiddenConstraint
    def matches?(request) = false
  end

  ROLES = {
    admin: AdminConstraint,
    user: UserConstraint
  }

  def authenticate(role, &)
    constraints(constraint_for(role), &)
  end

  private

  def constraint_for(role)
    ROLES[role.to_sym]&.new || ForbiddenConstraint.new
  end
end
