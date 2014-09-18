module Webhookr
  module Recurly
    module Generators

      class ExampleHooksGenerator < Rails::Generators::Base
        source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

        desc "Creates an example Recurly hook file: 'app/models/recurly_hooks.rb'"
        def example_hooks
          copy_file( "recurly_hooks.rb", "app/models/recurly_hooks.rb")
        end
      end

    end
  end
end
