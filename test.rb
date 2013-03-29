require_relative 'perm_check'
# brute force search for a set of three permutation fair dice 
# result:
# Dice #0: [0,5,7,11,12,16]
# Dice #1: [1,3,8,10,14,15]
# Dice #2: [2,4,6,9,13,17]
# state = '012120201210021102'
# puts perm_check(state)

num_players = 3
size = 6
total_number = num_players * size
total_search_space = num_players ** (total_number - 1) # minus one because we assume the smallest number is always player #0
signal_fraction = 0.00

output_file = File.open('output.txt', 'w')

total_search_space.times do |index|
  if index > total_search_space * signal_fraction
    puts "\nProgress: #{100 * index/total_search_space}\%"
    signal_fraction += 0.01
  end

  state = index.to_s(num_players)
  state = '0' * (total_number - state.length) + state

  valid = true
  num_players.times do |index_player|
    if state.count(index_player.to_s) != size
      valid = false
      break
    end
  end
  next if not valid

  if perm_check(state)
    puts "\n#{state}"
    output_file.write(state + "\n")
    output_file.flush
  end
end
