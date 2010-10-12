class Quickedit
  class Railtie < Rails::Railtie
    initializer "quickedit.helpers" do |app|
      ActionView::Base.send :include, Quickedit::Helpers
      app.middleware.use Quickedit
    end
  end
end
