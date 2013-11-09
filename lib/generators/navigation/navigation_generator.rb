require 'rails/generators'

module Navigation
  module Generators
    class NavigationGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "simple"

      attr_reader :app_name

      # Create a partial for navigation
      def generate_navigation
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        if framework_name == 'none'
          remove_file "app/views/layouts/_navigation.html.#{ext}"
          remove_file "app/views/layouts/_navigation_links.html.#{ext}"
        else
          copy_file "#{framework_name}-navigation.html.#{ext}", "app/views/layouts/_navigation.html.#{ext}"
          copy_file "navigation_links.html.erb", "app/views/layouts/_navigation_links.html.erb"
        end
      end

      # Add navigation links
      def add_navigation_links
        unless framework_name == 'none'
          append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'About', page_path('about') %></li>\n" if File.exists?('app/views/pages/about.html.erb')
          append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'Contact', new_contact_path %></li>\n" if File.exists?('app/views/contacts/new.html.erb')
        end
      end

    end
  end
end
