require 'erb'
require 'uri'
require 'rack'

require 'quickedit/adapter'
require 'quickedit/wrapper'
require 'quickedit/helpers'

require 'quickedit/backend'
require 'quickedit/static'

require 'quickedit/adapter/general'
require 'quickedit/adapter/active_record' if defined?(ActiveRecord)

require 'quickedit/railtie' if defined?(Rails)

class Quickedit
  class Error < StandardError; end
  ENABLE = 'quickedit.enable'.freeze
  INSTANCES = 'quickedit.instances'.freeze
    
  MIME_TYPES = ["text/html", "application/xhtml+xml"]
  STATUSES = [200]
  
  SCRIPT_TAG = '<script type="text/javascript" src="%s"></script>'
  SCRIPT_SRC = '/static/quickedit.js'
  
  def initialize(app, options = {})
    @app = app
    @options = options
    @mount_point = options[:mount] || '/__quickedit__'
    
    @backend = Quickedit::Backend.new
    @static = Quickedit::Static.new
  end
  
  def url_map
    @url_map ||= Rack::URLMap.new(
      (@mount_point + '/static') => @static,
      (@mount_point + '/backend') => @backend,
      '/' => @app
    )
  end
  
  def call(env)
    env[INSTANCES] = []
    result = url_map.call(env)
    result[1] = Rack::Utils::HeaderHash.new(result[1])
    
    if inject?(env) && response_is_injectable?(*result)
      result = inject!(env, *result)
    end
    
    return result
  end
  
  def inject?(env)
    env[ENABLE] && !env[INSTANCES].empty?
  end
  
  def response_is_injectable?(status, headers, body)
    STATUSES.include?(status) &&
    MIME_TYPES.include?(headers['Content-Type'].split(';').first)
  end
  
  def inject!(env, status, headers, body)
    body = BodyAppender.new(body, script)
      
    if len = headers['Content-Length']
      headers['Content-Length'] = (len.to_i + script.size).to_s
    end
    
    headers['Etag'] = ""
    headers['Cache-Control'] = "no-cache"
        
    return status, headers, body
  end
  
  def script
    SCRIPT_TAG % (@mount_point + SCRIPT_SRC)
  end
  
  class BodyAppender
    def initialize(body, append)
      @body = body
      @append = append
    end
    
    def each(&blk)
      @body.each(&blk)
      yield @append
      self
    end
    
    def close
      @body.close if @body.respond_to?(:close)
    end
  end
end
