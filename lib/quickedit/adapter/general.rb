class Quickedit
  class Adapters
    class General < Adapter
      + respond_to(:class)
      + respond_to(:id)
      + respond_to(:save)
    end
  end
end
