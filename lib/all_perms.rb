# returns all the permutations of an input string
# For example, if alphabet = '012', the return should be (up to order)
# ['012', '021', '102', '120', '201', '210']
# alphabet must not have identical characters

def all_perms(alphabet)
  if alphabet.kind_of?(Integer)
    string = ""
    alphabet.times do |index|
      string << index.to_s
    end
    return all_perms(string)
  end

  length = alphabet.length
  return [alphabet] if length <= 1 # base case
  
  output = []
  length.times do |index|
    first_char = alphabet[index]
    other_chars = alphabet[0,index] + alphabet[index+1, length]
    other_chars_perms = all_perms(other_chars)
    other_chars_perms.each do |other_perm|
      output << first_char + other_perm
    end
  end
  output
end