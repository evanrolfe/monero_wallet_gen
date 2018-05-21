# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monero_wallet_gen/version'

Gem::Specification.new do |spec|
  spec.name          = "monero_wallet_gen"
  spec.version       = MoneroWalletGen::VERSION
  spec.authors       = ["Evan Rolfe"]
  spec.email         = ["evanrolfe@gmail.com"]

  spec.summary       = %q{Lets you generate a fully functional monero address which you can send money to.}
  spec.homepage      = "https://github.com/evanrolfe/monero_wallet_gen"
  spec.license       = "MIT"
  spec.metadata      = { "source_code_uri" => "https://github.com/evanrolfe/monero_wallet_gen" }

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'digest-sha3'
  spec.add_development_dependency "bundler", "~> 1.16.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
