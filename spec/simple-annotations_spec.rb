# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'simple-annotations'
end

RSpec.describe Annotations do
  context 'base' do
    it 'has a version number' do
      expect(Annotations::VERSION).not_to be nil
    end
  end
end
