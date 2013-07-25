require 'action_view'
require 'link_to_active_state'

module LinkToActiveState
  module ViewHelpers
    module UrlHelper
      def self.included(base)
        base.send(:alias_method_chain, :link_to, :active_state)
      end

      def link_to_with_active_state(*args, &block)
        options = {}

        link_options, html_options = if block_given?
          [args.first, args.second]
        else
          [args[1], args[2]]
        end

        link_options ||= {}
        html_options ||= {}
        wrapper_options = html_options.delete(:active_wrapper_options) || {}

        if html_options.present? && html_options[:active_on].present?
          active_on = html_options.delete(:active_on)
          active_state = html_options.delete(:active_state) || "active"

          if is_active?(active_on, link_options, html_options)
            case active_state
            when Proc
              options = options.merge(active_state.call(html_options))
            when String
              options[:class] = merge_class(html_options[:class], active_state)
            end
          end
        end

        if html_options.present? && html_options[:active_wrapper]
          if wrapper_options[:class].present?
            options[:class] = merge_class(wrapper_options[:class], options[:class])
          end

          element_or_proc = html_options.delete(:active_wrapper)
          wrapper_options.merge!(options)

          render_with_wrapper(element_or_proc, wrapper_options) do
            link_to_without_active_state(*args, &block)
          end
        else
          html_options.merge!(options)
          link_to_without_active_state(*args, &block)
        end
      end

      private
      def is_active?(active_on, link_options = {}, html_options = {})
        if html_options.present? && html_options[:ignore_query]
          path = request.fullpath.gsub( /\?.*/, "" )
        else
          path = request.fullpath
        end

        case active_on
        when String
          path == active_on
        when Array
          active_on.include?(path)
        when Regexp
          path =~ active_on
        when Proc
          active_on.arity == 1 ? active_on.call(request) : active_on.call
        else
          # Anything else we'll take as a true argument, and match the link's URL (including any query string)
          url = url_for(link_options)
          path == url
        end
      end

      def merge_class(original, new)
        original ||= ""
        [original, new].delete_if(&:blank?).join(" ")
      end

      def render_with_wrapper(element_or_proc, wrapper_options, &block)
        content = block.call

        case element_or_proc
        when Proc
          element_or_proc.call(content, wrapper_options)
        when Symbol || String
          content_tag(element_or_proc, content, wrapper_options)
        end
      end
    end
  end
end
