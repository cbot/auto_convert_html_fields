$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auto_convert_html_fields/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auto_convert_html_fields"
  s.version     = AutoConvertHtmlFields::VERSION
  s.authors     = "cbot"
  s.email       = "kai@cbot-gsm.de"
  s.homepage    = "http://www.der-mtv.de"
  s.summary     = "converts html fields ;-)"
  s.description = "converts html fields ;-)"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = []

  s.add_dependency "rails", "> 3.0.0"
  s.add_dependency "cbot-bbcodeizer"
end
