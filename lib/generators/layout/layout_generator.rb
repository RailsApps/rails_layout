require 'rails/generators'

module Layout
  module Generators
    class LayoutGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "simple"

      attr_reader :app_name

      # Install the desired framework
      def install_framework
        remove_file 'app/assets/stylesheets/application.css'
        copy_file 'application.css.scss', 'app/assets/stylesheets/application.css.scss'
        case framework_name
          when 'bootstrap2'
            copy_file 'bootstrap2_and_overrides.css.scss', 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
          when 'bootstrap3'
            copy_file 'bootstrap3_and_overrides.css.scss', 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
          when 'foundation4'
            copy_file 'foundation_and_overrides.css.scss', 'app/assets/stylesheets/foundation_and_overrides.css.scss'
            copy_file 'foundation4-application.js', 'app/assets/javascripts/application.js'
        end
      end

      # Create an application layout file with partials for messages and navigation
      def generate_layout
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        # I've got templates for ERB and Haml (but not Slim)
        template "#{framework_name}-application.html.#{ext}", "app/views/layouts/application.html.#{ext}"
        copy_file "#{framework_name}-messages.html.#{ext}", "app/views/layouts/_messages.html.#{ext}"
        copy_file "#{framework_name}-navigation.html.#{ext}", "app/views/layouts/_navigation.html.#{ext}"
      end

      # Add a simple stylesheet if there is no front-end framework
      def simple_css
        if framework_name == 'simple'
          copy_file 'simple.css', 'app/assets/stylesheets/simple.css'
        else
          remove_file 'app/assets/stylesheets/simple.css'
        end
      end

      # If 'About' or 'Contact' views exist in known locations, add navigation links
      def add_navigation_links
        # not yet accommodating Slim (we'll need different substitutions)
        if File.exists?('app/views/pages/about.html.erb')
          insert_into_file 'app/views/layouts/_navigation.html.erb', "\n  <li><%= link_to 'About', page_path('about') %></li>", :before => "\n</ul>"
        end
        if File.exists?('app/views/contacts/new.html.erb')
          insert_into_file 'app/views/layouts/_navigation.html.erb', "\n  <li><%= link_to 'Contact', new_contact_path %></li>", :before => "\n</ul>"
        end
        if File.exists?('app/views/contacts/new.html.haml')
          insert_into_file 'app/views/layouts/_navigation.html.haml', "\n  %li= link_to 'Contact', new_contact_path", :after => "root_path"
        end
        if File.exists?('app/views/pages/about.html.haml')
          insert_into_file 'app/views/layouts/_navigation.html.haml', "\n  %li= link_to 'About', page_path('about')", :after => "root_path"
        end
      end

    end
  end
end
