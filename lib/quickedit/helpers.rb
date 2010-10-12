require 'quickedit/wrapper'

class Quickedit
  module Helpers
    extend self
    
    def quickedit_with_env(env, instance)
      if env[ENABLE]
        Quickedit::Wrapper.new(self, env, instance)
      else
        instance
      end
    end
    
    def quickedit(instance)
      quickedit_with_env(@env || request.env, instance)
    end
  end
end
