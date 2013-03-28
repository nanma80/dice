require_relative 'perm_check'
# brute force search for a set of three permutation fair dice 
# result:
# Dice #0: [0,5,7,11,12,16]
# Dice #1: [1,3,8,10,14,15]
# Dice #2: [2,4,6,9,13,17]
state = '012120201210021102'
puts perm_check(state)
