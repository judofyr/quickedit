class Quickedit
  class Static < Rack::File
    DIRECTORY = File.expand_path("../static", __FILE__)
    
    def initialize
      super(DIRECTORY)
    end
  end
end
