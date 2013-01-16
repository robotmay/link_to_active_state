module LinkToActiveState
  module ViewHelpers
    alias_method :rails_link_to, :link_to

    def link_to(*args, &block)
      html_options = if block_given?
        args.second
      else
        args[2]
      end
    
      if html_options.present? && html_options[:active_on].present?
        active_on = html_options[:active_on]

        active = case active_on
        when String
          request.fullpath == active_on
        when Regexp
          request.fullpath =~ active_on  
        when Proc
          active_on.arity == 1 ? active_on.call(request) : active_on.call
        end

        if active
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

      rails_link_to(*args, &block)
    end

    private
    def merge_class(original, new)
      original ||= ""
      original = case original.last
      when nil || "" || " "
        new
      else
        " #{new}"
      end
    end
  end
end
