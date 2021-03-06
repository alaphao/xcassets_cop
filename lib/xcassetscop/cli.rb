# frozen_string_literal: true

require 'thor'
require_relative 'configfile_parser'
require_relative 'version'

module XCAssetsCop
  class CLI < Thor
    desc 'lint [CONFIG FILE]', 'lint files using the configuration file provided, looks for a xcassetscop.yml if no path is provided'
    def lint(config_path = nil)
      configfile_path = File.expand_path(config_path || './xcassetscop.yml')
      unless File.file? configfile_path
        puts "Can't find file on path: #{configfile_path}"
        return
      end
      puts "Using config file at #{configfile_path}"

      rules = ConfigfileParser.parse configfile_path
      amount_of_files = rules.reduce(0) { |acc, rule| rule.paths.size + acc }
      errors = Linter.lint_files rules

      puts "#{rules.size} rules found"
      puts "#{amount_of_files} files checked"
      if errors.size.positive?
        puts "Found #{errors.size} offenses:"
        puts errors
      else
        puts 'No errors found'
      end
    end

    desc 'version', 'print version'
    def version
      puts Version.version
    end
  end
end
