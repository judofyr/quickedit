class Quickedit
  class Wrapper   
    attr_accessor :context, :env, :instance
    
    def initialize(context, env, instance)
      @context = context
      @env = env
      @instance = instance
      @env[INSTANCES] << self
    end
    
    def adapter
      @adapter ||= Quickedit::Adapter.find_adapter(@instance)
    end
    
    def method_missing(key, *args, &blk)
      unless adapter.can_update?(key)
        raise Error, "The field `#{key}` is not editable"
      end
      
      InnerWrapper.new(adapter, key)
    end
    
    class InnerWrapper
      WRAPPER = %q{<span quickedit="%s">%s</span>}
      
      def initialize(adapter, key)
        @adapter = adapter
        @key = key
      end
      
      def value
        @adapter.get(@key)
      end
      
      def quickedit_info
        info = [@adapter.class, @adapter.type, @adapter.id, @key]
        URI.escape(Marshal.dump(info))
      end
      
      def wrap(value, safe = false)
        if !safe && !html_safe?(value)
          value = ERB::Util.html_escape(value)
        end
        
        html_safe(WRAPPER % [quickedit_info, value])
      end
      
      def to_s
        wrap(value)
      end
      
      def raw
        wrap(value, true)
      end
      
      private
      
      def html_safe(str)
        str.respond_to?(:html_safe) ? str.html_safe : str
      end
      
      def html_safe?(str)
        str.respond_to?(:html_safe?) && str.html_safe?
      end
    end
  end
end
