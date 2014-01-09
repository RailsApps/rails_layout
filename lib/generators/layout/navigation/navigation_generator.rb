require 'rails/generators'

module Layout
  module Generators
    class NavigationGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Adds links to a navigation bar."

      # Add navigation links
      def add_navigation_links
        app = ::Rails.application
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        copy_file "navigation_links.html.erb", "app/views/layouts/_navigation_links.html.erb"
        # ABOUT
        append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'About', page_path('about') %></li>\n" if File.exists?("app/views/pages/about.html.#{ext}")
        # CONTACT
        append_file 'app/views/layouts/_navigation_links.html.erb', "<li><%= link_to 'Contact', new_contact_path %></li>\n" if File.exists?("app/views/contacts/new.html.#{ext}")
        # DEVISE LOGIN and LOGOUT
        if Dir.glob("app/views/devise/sessions/new.html.{#{ext},erb}").any?
          append_file 'app/views/layouts/_navigation_links.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li><%= link_to 'Logout', destroy_user_session_path, :method=>'delete' %></li>
<% else %>
  <li><%= link_to 'Login', new_user_session_path %></li>
<% end %>
LINKS
          end
        end
        # DEVISE SIGN UP
        if Dir.glob("app/views/devise/registrations/new.html.{#{ext},erb}").any?
          append_file 'app/views/layouts/_navigation_links.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li><%= link_to 'Edit account', edit_user_registration_path %></li>
<% else %>
  <li><%= link_to 'Sign up', new_user_registration_path %></li>
<% end %>
LINKS
          end
        end
        # USERS LINK
        if Dir.glob("app/views/users/index.html.{#{ext},erb}").any?
          append_file 'app/views/layouts/_navigation_links.html.erb' do <<-LINKS
<% if user_signed_in? %>
  <li><%= link_to 'Users', users_path %></li>
<% end %>
LINKS
          end
        end
      end

    end
  end
end
