require "gem_publisher"

task :publish_gem do |t|
  gem = GemPublisher.publish_if_updated("govuk_security_audit.gemspec", :rubygems)
  puts "Published #{gem}" if gem
end
