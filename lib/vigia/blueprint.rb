# encoding: utf-8

module Vigia
  class Blueprint

    attr_reader :apib, :apib_source, :metadata

    def initialize apib_source
      @apib_source = apib_source
      @apib_parsed = RedSnow::parse(apib_source)
      @apib        = @apib_parsed.ast
      @metadata    = @apib.metadata
    end

    def inspector object
      case object
      when RedSnow::Blueprint
        { line: 0 }
      when RedSnow::ResourceGroup
        locate_in_source("# Group #{ object.name }")
      when RedSnow::Resource
        locate_in_source(object.uri_template)
      when RedSnow::Action
        locate_in_source("#{ object.name } [#{ object.method }]")
      else
        { line: 'undefined' }
      end
    end

    private

    def locate_in_source(text)
      match = {}
      apib_source.lines.each_with_index do |line, index|
        match = { line: index + 1 }  if line.strip.include?(text)

        break unless match.empty?
      end
      match
    end
  end
end
