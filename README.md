# DynamicStyles

This little gem add ability for your AR model to have a custom stylesheet, which plays nicely with asset pipeline.

## Installation

Add this line to your application's Gemfile:

    gem 'dynamic_styles'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamic_styles

## Usage

Let's say you have a multi-tennant app, and tennants have the ability to modify their styles, which are attributes of Layout AR model. Just add mount_stylesheet to your Layout model and you'll be able to use layout.scss.erb (the template name is the same as your model) which is gets rendered to assets/stylesheets/layout/filename.css. Filename is created with Layout model timestamp, so this template will be re-rendered when Layout instance gets updated.
In the template you will have 'layout' variable you can use to get the attributes needed. You will need to have some method like current_layout with the instance of you Layout model. To insert link to custom stylesheet in the application.html.erb file just use <link href="<%= @current_layout.dynamic_stylesheet.path %>" media="screen" rel="stylesheet">

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
