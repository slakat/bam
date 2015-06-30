module Scrapers
	class TypoGenerator
		@alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
		@vowels = "aeiouy"

    @arr_prox = Hash.new
    @arr_prox['a'] = ['q', 'w', 'z', 'x','s']
    @arr_prox['b'] = ['v', 'f', 'g', 'h', 'n',' ']
    @arr_prox['c'] = ['x', 's', 'd', 'f', 'v',' ']
    @arr_prox['d'] = ['x', 's', 'w', 'e', 'r', 'f', 'v', 'c']
    @arr_prox['e'] = ['w', 's', 'd', 'f', 'r','2','3','4']
    @arr_prox['f'] = ['c', 'd', 'e', 'r', 't', 'g', 'b', 'v']
    @arr_prox['g'] = ['r', 'f', 'v', 't', 'b', 'y', 'h', 'n']
    @arr_prox['h'] = ['b', 'g', 't', 'y', 'u', 'j', 'm', 'n']
    @arr_prox['i'] = ['u', 'j', 'k', 'l', 'o','9','8','7']
    @arr_prox['j'] = ['n', 'h', 'y', 'u', 'i', 'k', 'm']
    @arr_prox['k'] = ['u', 'j', 'm', 'l', 'o',',']
    @arr_prox['l'] = ['p', 'o', 'i', 'k', 'm',',','.',';']
    @arr_prox['m'] = ['n', 'h', 'j', 'k', 'l',',',' ']
    @arr_prox['n'] = ['b', 'g', 'h', 'j', 'm',' ']
    @arr_prox['o'] = ['i', 'k', 'l', 'p',';']
    @arr_prox['p'] = ['o', 'l',';','0']
    @arr_prox['r'] = ['e', 'd', 'f', 'g', 't','4','5']
    @arr_prox['s'] = ['q', 'w', 'e', 'z', 'x', 'c']
    @arr_prox['t'] = ['r', 'f', 'g', 'h', 'y','5','6']
    @arr_prox['u'] = ['y', 'h', 'j', 'k', 'i','7','8']
    @arr_prox['v'] = [' ', 'c', 'd', 'f', 'g', 'b']  
    @arr_prox['w'] = ['q', 'a', 's', 'd', 'e','2','3']
    @arr_prox['x'] = ['z', 'a', 's', 'd', 'c']
    @arr_prox['y'] = ['t', 'g', 'h', 'j', 'u']
    @arr_prox['z'] = ['x', 's', 'a']

    @arr_ort = Hash.new
    @arr_ort['g']=['j']
    @arr_ort['h']=['']
    @arr_ort['z']=['s']

    def self.getAllTypos s
      puts "Run all previous methods"
      kwds = []
      for keyword in insertedKey(s)
        kwds.append(keyword)
      end
      for keyword in skipLetter(s)
          kwds.append(keyword)
      end
      for keyword in doubleLetter(s)
          kwds.append(keyword)
      end
      for keyword in self.reverseLetter(s)
          kwds.append(keyword)
      end
      for keyword in self.wrongVowel(s)
          kwds.append(keyword)
      end
      for keyword in self.wrongKey(s)
          kwds.append(keyword)    
      end
      for keyword in self.ortError(s)
        kwds.append(keyword)    
      end
      return kwds
    end

		def self.insertedKey s
	  	puts "Produce a list of keywords using the `inserted key' method"
	    kwds = []

	    for i in 0..(s.length-1) do        
        for key in @arr_prox.keys
          if key == s[i]
    				for char in @arr_prox[key] do
    					kwds.append(s[0..i] << char << s[i+1..s.length])
    	      end
          end
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

      for l in @arr_prox[s[0]]
        kwds <<  l + s[1..s.length]          
      end

      for i in 1..s.length - 1
        for key in @arr_prox.keys
          if key == s[i]
            for letter in @arr_prox[key]
              kwd = s[0..i - 1] + letter + s[(i + 1)..s.length]          
              kwds.append(kwd)
            end
          end
        end
      end
                
     	return kwds
    end

    def self.ortError s
      puts "Produce a list of keywords with common ortographic errors"
      kwds = []

      for l in @arr_ort[s[0]]
        kwds <<  l + s[1..s.length]          
      end

      for i in 1..s.length - 1
        for key in @arr_ort.keys
          if key == s[i]
            for letter in @arr_ort[key]
              kwd = s[0..i - 1] + letter + s[(i + 1)..s.length]          
              kwds.append(kwd)
            end
          end
        end
      end


        # for i in range(0, len(s)):
        #     for key in arr_ort.keys():
        #         if key is s[i]:
        #             for char in arr_ort[key]:       
        #                 kwd = s[:i] + char + s[i+1:]
        #                 kwds.append(kwd)
      return kwds
    end


	end
end