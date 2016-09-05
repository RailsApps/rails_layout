require 'rails/generators'

module Layout
  module Generators
    class NavigationGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "simple"

      desc "Adds links to a navigation bar."

      # Add navigation links
      def add_navigation_links_for_bootstrap4
        return unless framework_name == 'bootstrap4'
        app = ::Rails.application
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        copy_file "navigation_links.html.erb", "app/views/layouts/_navigation_links.html.erb"
        # ABOUT
        append_file 'app/views/layouts/_navigation_links.html.erb', "<li class='nav-item'><%= link_to 'About', page_path('about'), class: 'nav-link' %></li>\n" if File.exists?("app/views/pages/about.html.#{ext}")
        # CONTACT
        append_file 'app/views/layouts/_navigation_links.html.erb', "<li class='nav-item'><%= link_to 'Contact', new_contact_path, class: 'nav-link' %></li>\n" if File.exists?("app/views/contacts/new.html.#{ext}")
        # DEVISE
        if File.exists?('config/initializers/devise.rb')
          create_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li class='nav-item'><%= link_to 'Edit account', edit_user_registration_path, class: 'nav-link' %></li>
  <li class='nav-item'><%= link_to 'Sign out', destroy_user_session_path, :method=>'delete', class: 'nav-link' %></li>
<% else %>
  <li class='nav-item'><%= link_to 'Sign in', new_user_session_path, class: 'nav-link' %></li>
  <li class='nav-item'><%= link_to 'Sign up', new_user_registration_path, class: 'nav-link' %></li>
<% end %>
LINKS
          end
        end
        # OMNIAUTH
        if File.exists?('config/initializers/omniauth.rb')
          create_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li class='nav-item'><%= link_to 'Sign out', signout_path, class: 'nav-link' %></li>
<% else %>
  <li class='nav-item'><%= link_to 'Sign in', signin_path, class: 'nav-link' %></li>
<% end %>
LINKS
          end
        end
        # USERS
        if Dir.glob("app/views/users/index.html.{#{ext},erb}").any?
          if User.column_names.include? 'role'
            # suitable for role-based authorization
            append_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <% if current_user.try(:admin?) %>
    <li class='nav-item'><%= link_to 'Users', users_path, class: 'nav-link' %></li>
  <% end %>
<% end %>
LINKS
            end
          else
            # suitable for simple authentication
            append_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li class='nav-item'><%= link_to 'Users', users_path, class: 'nav-link' %></li>
<% end %>
LINKS
            end
          end
        end
        # UPMIN (administrative dashboard)
        if File.exists?('config/initializers/upmin.rb')
          navlink = "    <li class='nav-item'><%= link_to 'Admin', '/admin', class: 'nav-link' %></li>"
          inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', navlink + "\n", :after => "<% if current_user.try(:admin?) %>\n"
        end
        # ADMINSTRATE (administrative dashboard)
        if File.exists?('config/railscomposer.yml')
          if Rails.application.config_for(:railscomposer)['dashboard'] == 'administrate'
            navlink = "    <li class='nav-item'><%= link_to 'Admin', '/admin', class: 'nav-link' %></li>
"
            inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', navlink + "\n", :after => "<% if current_user.try(:admin?) %>\n"
          end
        end
      end

      # Add navigation links
      def add_navigation_links
        return if framework_name == 'bootstrap4'
        app = ::Rails.application
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        copy_file "navigation_links.html.erb", "app/views/layouts/_navigation_links.html.erb"
        # ABOUT
        append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'About', page_path('about') %></li>\n" if File.exists?("app/views/pages/about.html.#{ext}")
        # CONTACT
        append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'Contact', new_contact_path %></li>\n" if File.exists?("app/views/contacts/new.html.#{ext}")
        # DEVISE
        if File.exists?('config/initializers/devise.rb')
          create_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li><%= link_to 'Edit account', edit_user_registration_path %></li>
  <li><%= link_to 'Sign out', destroy_user_session_path, :method=>'delete' %></li>
<% else %>
  <li><%= link_to 'Sign in', new_user_session_path %></li>
  <li><%= link_to 'Sign up', new_user_registration_path %></li>
<% end %>
LINKS
          end
        end
        # OMNIAUTH
        if File.exists?('config/initializers/omniauth.rb')
          create_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li><%= link_to 'Sign out', signout_path %></li>
<% else %>
  <li><%= link_to 'Sign in', signin_path %></li>
<% end %>
LINKS
          end
        end
        # USERS
        if Dir.glob("app/views/users/index.html.{#{ext},erb}").any?
          if User.column_names.include? 'role'
            # suitable for role-based authorization
            append_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <% if current_user.try(:admin?) %>
    <li><%= link_to 'Users', users_path %></li>
  <% end %>
<% end %>
LINKS
            end
          else
            # suitable for simple authentication
            append_file 'app/views/layouts/_nav_links_for_auth.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li><%= link_to 'Users', users_path %></li>
<% end %>
LINKS
            end
          end
        end
        # UPMIN (administrative dashboard)
        if File.exists?('config/initializers/upmin.rb')
          navlink = "    <li><%= link_to 'Admin', '/admin' %></li>"
          inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', navlink + "\n", :after => "<% if current_user.try(:admin?) %>\n"
        end
        # ADMINSTRATE (administrative dashboard)
        if File.exists?('config/railscomposer.yml')
          if Rails.application.config_for(:railscomposer)['dashboard'] == 'administrate'
            navlink = "    <li><%= link_to 'Admin', '/admin' %></li>"
            inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', navlink + "\n", :after => "<% if current_user.try(:admin?) %>\n"
          end
        end
      end

      def modify_layout_for_auth_links
        return unless File.exists?('app/views/layouts/_nav_links_for_auth.html.erb')
        app = ::Rails.application
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        partial = "<%= render 'layouts/navigation_links' %>\n        <%= render 'layouts/nav_links_for_auth' %>"
        gsub_file "app/views/layouts/_navigation.html.#{ext}", /<%= render 'layouts\/navigation_links' %>/, partial
      end

      def add_tests
        return unless File.exists?('config/initializers/devise.rb')
        return unless File.exists?('spec/spec_helper.rb')
        copy_file 'navigation_spec.rb', 'spec/features/visitors/navigation_spec.rb'
      end

    end
  end
end
