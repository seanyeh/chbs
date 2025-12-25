require "option_parser"

module Chbs
  class CLI
    DEFAULT_WORD_COUNT = 5
    DEFAULT_SEPARATOR  = "-"

    def self.run
      word_count = DEFAULT_WORD_COUNT
      separator = DEFAULT_SEPARATOR
      copy_to_clipboard = false

      begin
        OptionParser.parse do |parser|
          parser.banner = "chbs - Correct Horse Battery Staple passphrase generator\n\nUsage: chbs [options]"

          parser.on("-n WORDS", "--words=WORDS", "Number of words (default: #{DEFAULT_WORD_COUNT})") do |n|
            word_count = n.to_i
          end

          parser.on("-s SEP", "--separator=SEP", "Separator between words (default: -)") do |sep|
            separator = sep
          end

          parser.on("-c", "--copy", "Copy to clipboard instead of printing") do
            copy_to_clipboard = true
          end

          parser.on("-v", "--version", "Show version") do
            puts "chbs v#{VERSION}"
            exit
          end

          parser.on("-h", "--help", "Show this help") do
            puts parser
            puts "\nExamples:"
            puts "  chbs                    Generate #{DEFAULT_WORD_COUNT}-word passphrase"
            puts "  chbs -n 6               Generate 6-word passphrase"
            puts "  chbs -s \" \"             Use space as separator"
            puts "  chbs -c                 Copy passphrase to clipboard"
            exit
          end
        end

        # Generate passphrase
        passphrase = Generator.generate(word_count, separator)

        if copy_to_clipboard
          Clipboard.copy(passphrase)
          puts "Passphrase copied to clipboard!"
        else
          puts passphrase
        end
      rescue ex : OptionParser::InvalidOption | OptionParser::MissingOption
        STDERR.puts "Error: #{ex.message}"
        STDERR.puts "Run 'chbs --help' for usage information"
        exit 1
      rescue ex
        STDERR.puts "Error: #{ex.message}"
        exit 1
      end
    end
  end
end
