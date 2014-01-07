require 'rails/generators'

module Views
  module Generators
    class ViewsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "simple"

      # Add stylesheet for Devise views
      def add_devise_stylesheet
        copy_file 'devise.css.scss', 'app/assets/stylesheets/devise.css.scss'
      end

      # Add Devise views
      def add_devise_views
        case framework_name
          when 'none'
            remove_file 'app/assets/stylesheets/devise.css.scss'
            remove_file 'app/views/devise/sessions/new.html.erb'
          when 'simple'
            # TODO
          when 'bootstrap2'
            # TODO
          when 'bootstrap3'
            copy_file 'sessions/new.html.erb', 'app/views/devise/sessions/new.html.erb'
          when 'foundation4'
            # TODO
          when 'foundation5'
            # TODO
        end
      end

    end
  end
end
