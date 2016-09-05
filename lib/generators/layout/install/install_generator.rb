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
            remove_file 'app/assets/stylesheets/1st_load_framework.css.scss'
          when 'simple'
            copy_file 'simple.css', 'app/assets/stylesheets/simple.css'
            copy_file 'application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
            remove_file 'app/assets/stylesheets/1st_load_framework.css.scss'
          when 'bootstrap2'
            copy_file 'bootstrap2_and_overrides.css.scss', 'app/assets/stylesheets/1st_load_framework.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
          when 'bootstrap3'
            copy_file 'bootstrap3_and_overrides.css.scss', 'app/assets/stylesheets/1st_load_framework.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
          when 'bootstrap4'
            copy_file 'bootstrap4_and_overrides.css.scss', 'app/assets/stylesheets/1st_load_framework.css.scss'
            copy_file 'bootstrap-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/foundation_and_overrides.css.scss'
          when 'foundation4'
            copy_file 'foundation4_and_overrides.css.scss', 'app/assets/stylesheets/1st_load_framework.css.scss'
            copy_file 'foundation4-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
          when 'foundation5'
            copy_file 'foundation5_and_overrides.css.scss', 'app/assets/stylesheets/1st_load_framework.css.scss'
            copy_file 'foundation5-application.js', 'app/assets/javascripts/application.js'
            remove_file 'app/assets/stylesheets/simple.css'
            remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.scss'
            insert_into_file('config/application.rb', "\n\n    # For Foundation 5\n    config.assets.precompile += %w( vendor/modernizr )\n", :after => /^ *# config.i18n.default_locale = :de/, :force => false)
        end
        if Rails::VERSION::MAJOR.to_s == "3"
          gsub_file 'app/assets/javascripts/application.js', /\/\/= require turbolinks\n/, ''
        end
      end

      def add_forms_stylesheet
        return unless (File.exists?('config/initializers/devise.rb') or File.exists?('config/initializers/omniauth.rb'))
        dir = File.expand_path("../templates", __FILE__)
        case framework_name
          when 'none'
            # TODO
          when 'simple'
            # TODO
          when 'bootstrap2'
            # TODO
          when 'bootstrap3'
            append_file 'app/assets/stylesheets/1st_load_framework.css.scss', File.read("#{dir}/bootstrap3-forms.css.scss")
          when 'bootstrap4'
            append_file 'app/assets/stylesheets/1st_load_framework.css.scss', File.read("#{dir}/bootstrap4-forms.css.scss")
          when 'foundation4'
            # TODO
          when 'foundation5'
            append_file 'app/assets/stylesheets/1st_load_framework.css.scss', File.read("#{dir}/foundation5-forms.css.scss")
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
      def add_navigation_links_for_bootstrap4
        return unless framework_name == 'bootstrap4'
        app = ::Rails.application
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        unless framework_name == 'none'
          # ABOUT
          append_file 'app/views/layouts/_navigation_links.html.erb', "<li class='nav-item'><%= link_to 'About', page_path('about'), class: 'nav-link' %></li>\n" if File.exists?("app/views/pages/about.html.#{ext}")
          # CONTACT
          append_file 'app/views/layouts/_navigation_links.html.erb', "<li class='nav-item'><%= link_to 'Contact', new_contact_path, class: 'nav-link' %></li>
\n" if File.exists?("app/views/contacts/new.html.#{ext}")
        end
      end

      # Add navigation links
      def add_navigation_links
        return if framework_name == 'bootstrap4'
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
