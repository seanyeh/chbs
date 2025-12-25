module Chbs
  class Generator
    WORDLIST_DATA = {{ read_file("#{__DIR__}/../../wordlist.txt") }}

    def self.generate(word_count : Int32, separator : String) : String
      wordlist = load_wordlist

      if word_count < 1
        raise "Word count must be at least 1"
      end

      selected_words = word_count.times.map { wordlist.sample }.to_a
      selected_words.join(separator)
    end

    private def self.load_wordlist : Array(String)
      words = WORDLIST_DATA.lines.map(&.strip).reject(&.empty?)

      if words.empty?
        raise "No words loaded from wordlist"
      end

      words
    end
  end
end
