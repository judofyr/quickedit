class Quickedit
  class Backend
    def call(env)
      request = Rack::Request.new(env)
      params = request.params
      case params['action']
      when 'save'
        adapter_klass, type, id, key = Marshal.load(URI.decode(params['instance']))
        adapter = adapter_klass.find(type, id)
        adapter.update(key, params['value'])
      end
      
      [200, {'Content-Type' => 'text/html'}, []]
    end
  end
end
