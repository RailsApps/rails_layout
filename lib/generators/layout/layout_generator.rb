require 'rails/generators'

module RailsLayout
  module Generators
    class LayoutGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "bootstrap2"

      attr_reader :app_name

      def generate_layout
        app = ::Rails.application
        @app_name = app.class.to_s.split("::").first
        ext = app.config.generators.options[:rails][:template_engine] || :erb
        template "#{framework_name}-application.html.#{ext}", "app/views/layouts/application.html.#{ext}"
        copy_file "#{framework_name}-navigation.html.#{ext}", "app/views/layouts/_navigation.html.#{ext}"
        copy_file "#{framework_name}-messages.html.#{ext}", "app/views/layouts/_messages.html.#{ext}"
      end
    end
  end
end
