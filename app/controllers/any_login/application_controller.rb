module AnyLogin
  class ApplicationController < ActionController::Base

    if AnyLogin.enabled
      if AnyLogin.http_basic_authentication_enabled
        http_basic_authenticate_with :name => AnyLogin.http_basic_authentication_user_name,
                                     :password => AnyLogin.http_basic_authentication_password
      end
    end

    def any_login
      try_not_to_leak_any_login_is_installed
      head 403 && return unless AnyLogin.verify_access_proc.call(self)
      AnyLogin.provider::Controller.instance_method(:any_login_sign_in).bind(self).call
    end

    private

    def try_not_to_leak_any_login_is_installed
      try_to_render_404_not_found unless AnyLogin.enabled
    end

    def try_to_render_404_not_found
      raise ActiveRecord::RecordNotFound
    end

  end
end
