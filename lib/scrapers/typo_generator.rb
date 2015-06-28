module Scrapers
	class TypoGenerator
		@alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
		@vowels = "aeiouy"

		def self.insertedKey s
	  	puts "Produce a list of keywords using the `inserted key' method"
	    kwds = []

	    for i in 0..(s.length) do
				for char in @alphabet.split("") do
					kwds.append(s[0..i] << char << s[i..s.length])
	      end
	    end
			kwds
		end

		def self.skipLetter s
      puts "Produce a list of keywords using the `skip letter' method"
      kwds = []
      kwds.append(s[1..s.length])
      for i in 2..(s.length) do
      	puts s[0..(i-2)] << s[i..s.length]
       	kwds.append(s[0..(i-2)] << s[i..s.length])
      end

      kwds
    end

    def self.doubleLetter s
      puts "Produce a list of keywords using the `double letter' method"
      kwds = []

      for i in 0..(s.length - 1) do
      	puts s[0..i] << s[i] << s[i+1..s.length]
      	kwds.append(s[0..i] << s[i] << s[i+1..s.length])
      end

      kwds
    end

    def self.reverseLetter s
      puts "Produce a list of keywords using the `reverse letter' method"
      kwds = []
      
      kwds.append(s[1] << s[0] << s[2..s.length])
      for i in 0..(s.length - 3) do
        letters = s[(i + 1)..(i + 3)]
                
        reverse_letters = letters[1] << letters[0]        
        kwds.append(s[0..i] << reverse_letters << s[(i + 3)..s.length])
      end
      kwds
    end

    def self.wrongVowel s
      puts "Produce a list of keywords using the `wrong vowel' method (for soundex)"
      kwds = []

      for i in 0..s.length-1 do
        for letter in @vowels.split("") do
          if @vowels.include?(s[i])
            for vowel in @vowels.split("") do
              s_list = s.split("")
              s_list[i] = vowel
              kwd = s_list.join("")
              puts kwd
              kwds.append(kwd)
            end
          end
        end
      end

      return kwds
    end

    def self.wrongKey s
      puts "Produce a list of keywords using the `wrong key' method"
      kwds = []

      for i in 0..s.length - 1
        for letter in @alphabet.split("")
          kwd = s[0..i] + letter + s[(i + 1)..s.length]
          puts kwd
          kwds.append(kwd)
        end
      end
                
     	return kwds
    end


	end
end