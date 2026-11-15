module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private

    def require_admin
      unless Current.user&.admin?
        head :forbidden
      end
    end
  end
end