require 'action_view'
require 'link_to_active_state'

module LinkToActiveState
  module ViewHelpers
    module UrlHelper
      def self.included(base)
        base.send(:alias_method_chain, :link_to, :active_state)
      end

      def link_to_with_active_state(*args, &block)
        html_options = if block_given?
          args.second
        else
          args[2]
        end

        if html_options.present? && html_options[:active_on].present?
          active_on = html_options[:active_on]

          if is_active?(active_on)
            active_state = html_options[:active_state] || "active"
            case active_state
            when Proc
              html_options.merge(active_state.call(html_options))
            when String
              html_options[:class] = merge_class(html_options[:class], active_state)
            end
          end

          html_options.delete(:active_on)
          html_options.delete(:active_state)
        end

        if html_options.present? && html_options[:active_wrapper]
          element = html_options.delete(:active_wrapper)

          content_tag(element, html_options) do
            link_to_without_active_state(*args, &block)
          end
        else
          link_to_without_active_state(*args, &block)
        end
      end

      private
      def is_active?(active_on)
        case active_on
        when String
          request.fullpath == active_on
        when Array
          active_on.include?(request.fullpath)
        when Regexp
          request.fullpath =~ active_on
        when Proc
          active_on.arity == 1 ? active_on.call(request) : active_on.call
        end
      end

      def merge_class(original, new)
        original ||= ""
        [original, new].delete_if(&:blank?).join(" ")
      end
    end
  end
end
