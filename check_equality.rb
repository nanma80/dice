require_relative 'lib/perm_check'

state = 'abcddbaccbadcabddacbdbcadcbadcabbcaddacbbacdabcdacbdbcaddbacdabccabddcba'

puts perm_check(state)

state = '0101'

puts perm_check(state)


