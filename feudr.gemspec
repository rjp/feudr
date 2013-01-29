# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["cout", "rjp"]
  gem.description   = "Wordfeud client"
  gem.summary       = "REST Client for Wordfeud game API"
  gem.homepage      = "http://github.com/cout/feudr"

  gem.files         = ['lib/feudr/client.rb']
  gem.name          = "feudr"
  gem.require_paths = ["lib"]
  gem.version       = 0.1

  gem.add_development_dependency 'rest-client'
end
