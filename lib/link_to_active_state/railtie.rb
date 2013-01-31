require "link_to_active_state"

module LinkToActiveState
  class Railtie < Rails::Railtie
    initializer "link_to_active_state.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        require "link_to_active_state/view_helpers/url_helper"
        include LinkToActiveState::ViewHelpers::UrlHelper
      end
    end
  end
end
