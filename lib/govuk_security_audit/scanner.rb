require "bundler/audit/database"
require "bundler/audit/scanner"
require "bundler/lockfile_parser"

module GovukSecurityAudit
  class Scanner < Bundler::Audit::Scanner
    def initialize(path=Dir.pwd)
      path = File.expand_path(path)
      if File.directory?(path)
        path = File.join(path, "Gemfile.lock")
      end

      @root = File.dirname(path)
      @database = Bundler::Audit::Database.new
      @lockfile = Bundler::LockfileParser.new(File.read(path))
    end
  end
end
