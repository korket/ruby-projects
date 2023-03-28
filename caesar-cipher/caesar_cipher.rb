def caesar_cipher(string, shift)
  string = string.split('')
  new_string = []

  string.each do |letter|
    letter = letter.ord

    # uppercase letters

    if letter >= 65 and letter <= 90
      letter = letter + shift
      if letter > 90
        letter = letter - 90 + 65
      elsif letter < 65
        letter = letter - 65 + 90
      end
    end

    # lowercase letters

    if letter >= 97 and letter <= 122
      letter = letter + shift
      if letter > 122
        letter = letter - 122 + 97
      elsif letter < 97
        letter = letter - 97 + 122
      end
    end

    new_string.push(letter.chr)
  end

  puts new_string.join('')
end

caesar_cipher("This is awesome!", 2)
caesar_cipher("Vjku ku cyguqog!", -2)
caesar_cipher("Everything is good so far", 5)
caesar_cipher("Jbjweymnsl nx ltti xt kfw", -5)