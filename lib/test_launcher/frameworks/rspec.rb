require "test_launcher/frameworks/base"

module TestLauncher
  module Frameworks
    module RSpec

      def self.active?
        ! Dir.glob("**/*_spec.rb").empty?
      end

      class Runner < Base::Runner
        def single_example(result)
          method_name = result.line[/\s*(?:it|context|(?:RSpec\.)?describe)\s+(?:"|')?([^'"]*)(?:"|')?\s+do\s*/, 1]
          %{cd #{result.app_root} && rspec #{result.relative_test_path} --example '#{method_name}'}
        end

        def one_or_more_files(results)
          %{cd #{results.first.app_root} && rspec #{results.map(&:relative_test_path).join(" ")}}
        end
      end

      class SearchResults < Base::SearchResults
        private

        def file_name_regex
          /.*_spec\.rb/
        end

        def file_name_pattern
          '*_spec.rb'
        end

        def regex_pattern
          "^\s*(it|context|(RSpec.)?describe) .*#{query}.* do.*"
        end

        def test_root_folder_name
          "spec"
        end
      end
    end
  end
end