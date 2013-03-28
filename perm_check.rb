# source: https://code.google.com/p/gofirstdice/wiki/FastPermCheck
# This algorithm was created by Landon Kryger to solve the problem of testing if a set of dice is fair. If you have n players and s sides, the standard approach would require you to test every roll and would run in O(s^n). This algorithm runs in approximately O(s*n*n!). For small s,n, it's not a very noticeable difference, but for large values like n=5;s=30 the benefit is huge.
# This algorithm also works with dice with different number of sides.

# The input can be either a string, e.g.
# state = 'abcddbaccbadcabddacbdbcadcbadcabbcaddacbbacdabcdacbdbcaddbacdabccabddcba'
# or an array of characters, e.g.
# state = ['0', '1', '1', '0']
# The output, count, will contain how many ways each substring can occur.

def perm_check(state)
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

# state = 'abcddbaccbadcabddacbdbcadcbadcabbcaddacbbacdabcdacbdbcaddbacdabccabddcba'
# full_test(state)
