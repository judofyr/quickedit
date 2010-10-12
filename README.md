Quickedit
=========

Quickedit is an embeddable micro-CMS for Rails, Sinatra and Rack which allows
you to easily edit any content in-place. Perfect for adding temporary editing
capabilities to any app.

Installation
------------

### Step 1

Install the Quickedit gem:

    # Rails 3 (Bundler): Add to Gemfile
    gem "quickedit"
    
    # Other frameworks:
    #   Install the gem:     `gem install quickedit`
    #   Add to your app:     require 'quickedit'
    #   Add the middleare:   use Quickedit
    #   Include the helpers: include Quickedit::Helpers

### Step 2

Enable Quickedit for some users:

    # Example for Rails 3
    class ApplicationController
      before_filter do
        # Enable for all users in this case
        env['quickedit.enable'] = true
      end
    end

### Step 3

Change your view from:

    <h2><%= @post.title %></h2>
    
To:

    <h2><%= quickedit(@post).title %></h2>

**You're done! Visit the page in your browser.**


Automatic escaping
------------------

Quickedit will automatically escape the value (unless it's already been marked
HTML safe). If you want to output the raw HTML please use the #raw method:

    <h2><%= quickedit(@post).title.raw %></h2>


Acknowledgements
----------------

Quickedit is based on [rack-cms](http://github.com/brennandunn/rack-cms)
written by Brennan Dunn.

Contributing
------------

Once you've made your great commits:

1. [Fork][fk] Quickedit
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create an [Issue][is] with a link to your branch
5. That's it!

[fk]: http://help.github.com/forking/
[is]: http://github.com/judofyr/quickedit/issues

