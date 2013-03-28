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
total_search_space = num_players ** total_number
signal_fraction = 0.00

total_search_space.times do |index|
  if index > total_search_space * signal_fraction
    puts "\nProgress: #{100 * index/total_search_space}\%"
    signal_fraction += 0.01
  end

  state = index.to_s(3)
  state = '0' * (total_number - state.length) + state

  valid = true
  num_players.times do |index_player|
    if state.count(index_player.to_s) != size
      valid = false
      break
    end
  end
  next if not valid

  count = perm_check(state)

  next if count['01'] != count['10']
  next if count['12'] != count['21']
  next if count['02'] != count['20']

  perm_count = (size ** num_players) / 6.0

  next if count['012'] != perm_count
  next if count['120'] != perm_count
  next if count['201'] != perm_count
  next if count['210'] != perm_count
  next if count['102'] != perm_count
  next if count['021'] != perm_count

  puts "\n#{state}"
  # break
end
