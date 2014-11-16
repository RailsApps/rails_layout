require 'rails/generators'

module Layout
  module Generators
    class DeviseGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "simple"

      desc "Copies Devise views to your application, with styling for a front-end framework."

      def add_devise_views
        copy_file 'sessions/new.html.erb', 'app/views/devise/sessions/new.html.erb'
        copy_file 'passwords/new.html.erb', 'app/views/devise/passwords/new.html.erb'
        copy_file 'passwords/edit.html.erb', 'app/views/devise/passwords/edit.html.erb'
        unless File.exists?('app/views/devise/registrations/new.html.erb')
          copy_file 'registrations/new.html.erb', 'app/views/devise/registrations/new.html.erb'
        end
        copy_file 'registrations/edit.html.erb', 'app/views/devise/registrations/edit.html.erb'
      end

      def add_name_field
        if Object.const_defined?('User')
          if User.column_names.include? 'name'
            gsub_file 'app/views/devise/registrations/new.html.erb', /:autofocus => true, /, ''
            gsub_file 'app/views/devise/registrations/edit.html.erb', /:autofocus => true, /, ''
            inject_into_file 'app/views/devise/registrations/new.html.erb', name_field, :before => "      <%= f.label :email %>"
            inject_into_file 'app/views/devise/registrations/edit.html.erb', name_field, :before => "      <%= f.label :email %>"
          end
        end
      end

      private

      def name_field
<<-TEXT
      <%= f.label :name %>
      <%= f.text_field :name, :autofocus => true, class: 'form-control' %>
    </div>
    <div class="form-group">
TEXT
      end

    end
  end
end
