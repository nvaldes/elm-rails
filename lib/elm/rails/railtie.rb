require 'rails'
require 'elm/rails/sprockets'

module Elm
  module Rails
    class Railtie < ::Rails::Railtie
      initializer 'elm-rails.setup_view_helpers', group: :all do
        ActiveSupport.on_load(:action_view) do
          include ::Elm::Rails::Helper
        end
      end

      initializer 'elm-rails.setup_engine', group: :all do |app|
        sprockets_env = app.assets || app.config.assets
        Dir[app.root.join('app', 'assets', 'elm')].each do |path|
          sprockets_env.append_path(path)
        end

        config.assets.configure do |env|
          env.register_mime_type 'text/x-elm', extensions: ['.elm']

          if Gem::Version.new(Sprockets::VERSION) >= Gem::Version.new('3.0.0')
            env.register_transformer 'text/x-elm', 'application/javascript', Elm::Rails::Sprockets
          else
            env.register_engine '.elm', Elm::Rails::Sprockets
          end
        end
      end
    end
  end
end
