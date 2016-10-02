#!/usr/bin/env ruby

# Using nokogiri xml library because of its ease of use, ease of installation and speed.
require 'nokogiri'

# Trying to learn some OO concepts in Ruby. Ruby doesn't have a native interface model for classes. Everything is inherited.
# ToDo: Study the concepts presented here: http://metabates.com/2011/02/07/building-interfaces-and-abstract-classes-in-ruby/

module Poem
  class InterfaceNotImplementedError < NoMethodError
  end

  class PoemQueue
    # Not using attr_accessor because we don't want accidentally call the writer when adding to the lines array.
    # we also want the poetry_type and number_of_lines_required to be immutable

    # constant definition without warnings: http://stackoverflow.com/questions/7953611/solutions-to-the-annoying-warning-already-initialized-constant-message

    LINE_WORDS ||= %w[none one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eightteen nineteen twenty]
    RHYME_POSTFIXES ||= %w[]

    def get_poetry_type()
      @poetry_type
    end

    def get_number_of_lines_required()
      @number_of_lines_required
    end

    def initialize( poetry_type, number_of_lines_required )
      @poetry_type = poetry_type
      @number_of_lines_required = number_of_lines_required
      @lines = []
    end

    def clear()
      @lines.clear
    end

    def get_lines()
      @lines
    end

    def add( line )
      # puts "Attempting to add '#{line}'"
      if ( @lines.length < get_number_of_lines_required() )
        @lines.push( line )
      else
        raise IndexError, "#{poetry_type()}s may only have #{line_word[get_number_of_lines_required()]} lines. This additional line, '#{line}' will be dropped."
      end
    end

    def right_number_of_lines?()
      @lines.count == get_number_of_lines_required()
    end

    def puts_poem()
      if ( @lines.count == get_number_of_lines_required() )
        puts @lines.join("\n")
      else
        raise EncodingError, "#{poetry_type()}s must have exactly {line_word[get_number_of_lines_required()]} lines. This one has #{@line_word[@lines.count]}."
      end
    end
  end # PoemQueue

  class PoemLineDefinition
    # this class is for storing attributes of each line
    attr_accessor :rhyming_value
    attr_accessor :line_text

    def initialize( *parameters )
      if parameters[0].nil?
        raise ArgumentError, "A number of syllables for this line must be provided. The rhyming id is optional."
      end
      _initialize( parameters[0], parameters[1] || nil )
    end

    def _initialize( number_of_syllables, line_to_rhyme_with )
      @number_of_syllables = number_of_syllables
      @line_to_rhyme_with = line_to_rhyme_with
    end

    def get_number_of_syllables()
      @number_of_syllables
    end

    def get_line_to_rhyme_with()
      @line_to_rhyme_with
    end
  end # PoemLineDefinition

  class PoemGeneratorInterface
    # this class needs to have the following items overwritten:
    # method: get_poetry_type
    # method: get_line_definitions

    def get_poetry_type()
      raise InterfaceNotImplementedError
    end

    def get_line_definitions()
      # returns an array of PoemLineDefinitions
      # E.G. [PoemLineDefinition.new(5), PoemLineDefinition.new(7), PoemLineDefinition.new(5)]
      raise InterfaceNotImplementedError
    end

    def do_line_definitions_include_syllable?( syllable_count )
      @line_definitions.each do |line_definition|
        if line_definition.get_number_of_syllables == syllable_count
          return true
        end
      end
      return false
    end

    def initialize( *parameters )
      if parameters[0].nil?
        raise ArgumentError, "A path to the Poem Definition file must be provided."
      end
      _initialize( parameters[0] )
    end

    def _initialize( file_path )
      @line_definitions = get_line_definitions()

      if do_line_definitions_include_syllable?( 0 )
        raise "You cannot have any lines that are zero syllables."
      end

      @my_incredible_poem = PoemQueue.new( get_poetry_type(), @line_definitions.count )

      read_poem_line_definitions( file_path )
      build_poem()
      puts_poem()
    end

    def read_poem_line_definitions( file_path )
      # put the data into two arrays:
      doc = Nokogiri::XML( File.open( file_path ) )
      @attribution_title = doc.xpath( "//lines/@title" )

      for l in 1..( PoemQueue::LINE_WORDS.count - 1 )
        # only if we need that line type (a line with that number of syllables) do we search for it with xpath.
        if do_line_definitions_include_syllable?( l )
          instance_variable_set( "@#{PoemQueue::LINE_WORDS[l]}_syllable_lines", doc.xpath( "//line[@syllables='#{l}']/@text" ) )
        end
      end
    end

    def build_poem()
      # a haiku's line_definitions = [5, 7, 5][nil, nil, nil] - the set of nils is because no line needs to rhyme with another line

      @line_definitions.each do |line_definition|
        begin
          @my_incredible_poem.add( get_poem_line_data( instance_variable_get( "@#{PoemQueue::LINE_WORDS[line_definition.get_number_of_syllables()]}_syllable_lines" ) ) )
        rescue => uh_oh
          puts "There was an issue: #{uh_oh}"
        end
      end
    end

    def puts_poem()
      puts "\nSource: #{@attribution_title}\n\n"
      begin
        @my_incredible_poem.puts_poem()
      rescue => uh_oh
        puts "There was an issue: #{uh_oh}"
      end
    end

    def get_poem_line_data( line_array )
      line_array[rand( line_array.count ) - 1]
    end
  end # PoemGeneratorInterface
end # Module Poem

__END__