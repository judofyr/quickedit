class Quickedit
  class Adapter
    class ActiveRecord < Adapter
      + is_a(::ActiveRecord::Base)
      
      def can_update?(key)
        instance.attributes.has_key?(key.to_s)
      end
    end
  end
end
