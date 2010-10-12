class Quickedit
  class Adapter
    attr_reader :instance
    
    def initialize(instance)
      @instance = instance
    end
    # Sensible defaults:
    
    def self.find(type, id)
      type.find(id)
    end
    
    def type
      instance.class
    end
    
    def id
      instance.id
    end
    
    def get(key)
      instance.send(key)
    end
    
    def can_update?(key)
      instance.respond_to?(key) &&
      instance.respond_to?("#{key}=")
    end
    
    def update(key, value)
      instance.send("#{key}=", value)
      instance.save
    end
    
    def self.adapters
      @adapters ||= []
    end
    
    def self.find(instance)
      adapter = adapters.reverse.detect { |a| a.matches?(instance) }
      
      if adapter.nil?
        raise Error, "Can't find adapter for #{instance.inspect}"
      end
      
      adapter.new(instance)
    end
    
    ## Rules
    
    def self.rules
      @rules ||= []
    end
    
    def self.matches?(instance)
      rules.all? { |r| r.matches?(instance) }
    end
    
    def self.rule(*args)
      Rule.new(*args).append(rules)
    end
    
    def self.is_a(*args)
      rule(:is_a, *args)
    end
    
    def self.respond_to(*args)
      rule(:respond_to, *args)
    end
    
    def self.inherited(mod)
      adapters << mod
      mod.rules.replace(rules)
    end
    
    class Rule
      attr_accessor :type, :values, :positive
      
      def initialize(type, *values)
        @type = type
        @values = values
        @positive = true
      end
      
      def append(rules)
        # Remove conflicting rules
        rules.delete_if do |rule|
          type == rule.type && values == rule.values
        end
        rules << self
        self
      end
      
      def +@
        @positive = true
      end
      
      def -@
        @positive = false
      end
      
      def matches?(instance)
        values.any? do |value|
          truthy = instance.send("#{@type}?", value)
          @positive ? truthy : !truthy
        end
      end
    end
  end
end
