#!/usr/bin/env ruby

load 'Poem.rb'

# --

module Haiku
  class Haiku < Poem::PoemGeneratorInterface
    # this class needs to have the following items overwritten:
    # method: get_poetry_type
    # method: get_line_definitions

    def get_poetry_type()
      # returns a string
      "Haiku"
    end

    def get_line_definitions()
      # returns an array of PoemLineDefinitions
      [Poem::PoemLineDefinition.new(5), Poem::PoemLineDefinition.new(7), Poem::PoemLineDefinition.new(5)]
    end
  end
end
