require_relative 'variance'

def score(state, level)
  counts = counts(state)
  array = []
  counts.each do |key, value|
    next if key.length != level
    array << value
  end

  array.variance
end

def perm_check(state)
  short_circuit_check(counts(state))
end

# source: https://code.google.com/p/gofirstdice/wiki/FastPermCheck
# This algorithm was created by Landon Kryger to solve the problem of testing if a set of dice is fair. If you have n players and s sides, the standard approach would require you to test every roll and would run in O(s^n). This algorithm runs in approximately O(s*n*n!). For small s,n, it's not a very noticeable difference, but for large values like n=5;s=30 the benefit is huge.
# This algorithm also works with dice with different number of sides.

# The input can be either a string, e.g.
# state = 'abcddbaccbadcabddacbdbcadcbadcabbcaddacbbacdabcdacbdbcaddbacdabccabddcba'
# or an array of characters, e.g.
# state = ['0', '1', '1', '0']
# The output, count, will contain how many ways each substring can occur.

def counts(state)
  counts = {'' => 1}
  state = state.split("") if state.kind_of?(String)
  state.each do |char|
    counts.keys.each do |key|
      if key.count(char) == 0
        key_char = key + char
        counts[key_char] = (counts[key_char] || 0) + counts[key]
      end
    end
  end
  counts
end

# counts_by_length takes counts hash as input and generates another hash, where the keys are the lengths of substrings (as a string), and the values are arrays containing the number of appearances.
def counts_by_length(counts)
  counts_by_length = {}
  counts.each do |key, value|
    l = key.length.to_s
    if counts_by_length.has_key?(l)
      counts_by_length[l] << value
    else
      counts_by_length[l] = [value]    
    end
  end
  counts_by_length
end

# short_circuit_check is similar to counts_by_length 
# but it does comparison as it builts the hash
# the comparison is stopped once the check result is clear
def short_circuit_check(counts)
  counts_by_length = {}

  counts.each do |key, value|
    l = key.length.to_s
    if counts_by_length.has_key?(l)
      if counts_by_length[l][0] != value
        return false 
      else
        counts_by_length[l][1] += 1
      end
    else
      counts_by_length[l] = [value, 1]
    end
  end
  complete?(counts_by_length)
end

# check if counts_by_length is complete

def complete?(counts_by_length)
  num_players = counts_by_length['1'][1]
  counts_by_length.each do |key, value|
    l = key.to_i
    if l > 1
      num_perms = 1
      l.times do |index|
        num_perms *= (num_players - index)
      end
      return false if num_perms != counts_by_length[key][1]
    end
  end
  true
end