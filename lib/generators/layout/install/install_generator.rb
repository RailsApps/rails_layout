require 'rails/generators'

module Layout
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "simple"

      desc "Creates Rails layout files suitable for various front-end frameworks."

      attr_reader :app_name

      # Install the desired framework
      def install_framework
        remove_file 'app/assets/stylesheets/application.css'
        copy_file 'application.css.scss', 'app/assets/stylesheets/application.css.scss'
        case framework_name
          when 'none'
            copy_file 'application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
            remove_file 'app/assets/stylesheets/framework_and_overrides.css.scss'
          when 'simple'
            copy_file 'simple.css', 'app/assets/stylesheets/simple.css'
            copy_file 'application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
            remove_file 'app/assets/stylesheets/framework_and_overrides.css.scss'
          when 'bootstrap2'
            copy_file 'bootstrap2_and_overrides.css.scss', 'app/assets/stylesheets/framework_and_overrides.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
          when 'bootstrap3'
            copy_file 'bootstrap3_and_overrides.css.scss', 'app/assets/stylesheets/framework_and_overrides.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
          when 'foundation4'
            copy_file 'foundation4_and_overrides.css.scss', 'app/assets/stylesheets/framework_and_overrides.css.scss'
            copy_file 'foundation4-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
          when 'foundation5'
            copy_file 'foundation5_and_overrides.css.scss', 'app/assets/stylesheets/framework_and_overrides.css.scss'
            copy_file 'foundation5-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
        end
        if Rails::VERSION::MAJOR.to_s == "3"
          gsub_file 'app/assets/javascripts/application.js', /\/\/= require turbolinks\n/, ''
        end
      end

      # Create an application layout file with partials for messages and navigation
      def generate_layout
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        remove_file 'app/views/layouts/application.html.erb'
        template "#{framework_name}-application.html.#{ext}", "app/views/layouts/application.html.#{ext}"
        if Rails::VERSION::MAJOR.to_s == "3"
          gsub_file "app/views/layouts/application.html.#{ext}", /, "data-turbolinks-track" => true/, ''
        end
        if framework_name == 'none'
          remove_file "app/views/layouts/_messages.html.#{ext}"
          remove_file "app/views/layouts/_navigation.html.#{ext}"
          remove_file "app/views/layouts/_navigation_links.html.#{ext}"
        else
          copy_file "#{framework_name}-messages.html.#{ext}", "app/views/layouts/_messages.html.#{ext}"
          copy_file "#{framework_name}-navigation.html.#{ext}", "app/views/layouts/_navigation.html.#{ext}"
          copy_file "navigation_links.html.erb", "app/views/layouts/_navigation_links.html.erb"
        end
      end

      # Add navigation links
      def add_navigation_links
        app = ::Rails.application
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        unless framework_name == 'none'
          # ABOUT
          append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'About', page_path('about') %></li>\n" if File.exists?("app/views/pages/about.html.#{ext}")
          # CONTACT
          append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'Contact', new_contact_path %></li>\n" if File.exists?("app/views/contacts/new.html.#{ext}")
        end
      end

    end
  end
end
