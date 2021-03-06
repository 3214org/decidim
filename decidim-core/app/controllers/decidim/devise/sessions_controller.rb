# frozen_string_literal: true
module Decidim
  module Devise
    # Custom Devise SessionsController to avoid namespace problems.
    class SessionsController < ::Devise::SessionsController
      include Decidim::DeviseControllers
      helper Decidim::OmniauthHelper

      def after_sign_in_path_for(user)
        return first_login_authorizations_path if first_login_and_not_authorized?(user) &&
                                                  !user.roles.include?("admin")
        super
      end

      # Calling the `stored_location_for` method removes the key, so in order
      # to check if there's any pending redirect after login I need to call
      # this method and use the value to set a pending redirect. This is the
      # only way to do this without checking the session directly.
      def pending_redirect?(user)
        store_location_for(user, stored_location_for(user))
      end

      def first_login_and_not_authorized?(user)
        user.is_a?(User) && user.sign_in_count == 1 && current_organization.available_authorizations.any?
      end

      def after_sign_out_path_for(user)
        request.referer || super
      end
    end
  end
end
