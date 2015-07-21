require "net/https"
require "uri"
require "thor"
require "bundler/audit/database"

require "govuk_security_audit/scanner"

module GovukSecurityAudit
  class CLI < Thor
    class_option :skip_update, type: :boolean, default: false

    desc "github USER REPO [REF]", "check the Github repo USER/REPO at an optional REF. Defaults to master."
    def github(user, repo, ref="master")
      update unless options[:skip_update]
      uri = URI.parse("https://raw.githubusercontent.com/#{user}/#{repo}/#{ref}/Gemfile.lock")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      if response.code != "200"
        say "Failed to fetch from Github: #{response.code} - #{response.message}", :red
        exit 1
      end

      file = Tempfile.new(["Gemfile", ".lock"])
      file.write(response.body)
      check(file.path)
    end

    desc "check [PATH]", "check the Gemfile at PATH, or the current directory."
    def check(path=Dir.pwd)
      update unless options[:skip_update]
      scanner    = Scanner.new(path)
      vulnerable = false

      scanner.scan do |result|
        vulnerable = true

        case result
        when Scanner::InsecureSource
          say "Insecure Source URI found: #{result.source}", :yellow
        when Scanner::UnpatchedGem
          print_advisory result.gem, result.advisory
        end
      end

      if vulnerable
        say "Vulnerabilities found!", :red
        exit 1
      else
        say "No vulnerabilities found", :green
      end
    end

    desc 'update', 'Updates the ruby-advisory-db'
    def update
      say "Updating ruby-advisory-db ..."

      Bundler::Audit::Database.update!
      puts "ruby-advisory-db: #{Bundler::Audit::Database.new.size} advisories"
    end

    private

    def print_advisory(gem, advisory)
      say "Name: ", :red
      say gem.name

      say "Version: ", :red
      say gem.version

      say "Advisory: ", :red

      if advisory.cve
        say "CVE-#{advisory.cve}"
      elsif advisory.osvdb
        say advisory.osvdb
      end

      say "Criticality: ", :red
      case advisory.criticality
      when :low    then say "Low"
      when :medium then say "Medium", :yellow
      when :high   then say "High", [:red, :bold]
      else              say "Unknown"
      end

      say "URL: ", :red
      say advisory.url

      if options.verbose?
        say "Description:", :red
        say

        print_wrapped advisory.description, :indent => 2
        say
      else

        say "Title: ", :red
        say advisory.title
      end

      unless advisory.patched_versions.empty?
        say "Solution: upgrade to ", :red
        say advisory.patched_versions.join(', ')
      else
        say "Solution: ", :red
        say "remove or disable this gem until a patch is available!", [:red, :bold]
      end

      say
    end

  end
end
