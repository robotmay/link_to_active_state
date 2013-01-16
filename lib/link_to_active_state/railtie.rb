require "link_to_active_state/view_helpers"

module LinkToActiveState
  class Railtie < Rails::Railtie
    initializer "link_to_active_state.view_helpers" do
      ActionView::Base.send(:include, ViewHelpers)
    end
  end
end
