# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{quickedit}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Magnus Holm"]
  s.date = %q{2010-10-12}
  s.email = %q{judofyr@gmail.com}
  s.files = ["README.md", "lib/quickedit.rb", "lib/quickedit/adapter.rb", "lib/quickedit/adapter/active_record.rb", "lib/quickedit/adapter/general.rb", "lib/quickedit/backend.rb", "lib/quickedit/helpers.rb", "lib/quickedit/railtie.rb", "lib/quickedit/static.rb", "lib/quickedit/static/quickedit.js", "lib/quickedit/wrapper.rb", "quickedit.gemspec", "spec/adapter_spec.rb", "spec/spec_helper.rb"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Micro-CMS for Rails, Sinatra and Rack}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
