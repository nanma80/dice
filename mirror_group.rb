require_relative 'lib/all_perms'
require_relative 'lib/perm_check'

num_players = 4
size = 12 # must be even
# Unfortunately, (4, 12) generates no result


perms = all_perms(num_players)
num_perms = perms.length

total_search_space = num_perms ** (size/2 - 1) # minus one because we assume the first group is 012...

puts total_search_space

signal_fraction = 0.00

output_file = File.open('output.txt', 'w')

total_search_space.times do |index|
  if index > total_search_space * signal_fraction
    puts "\nProgress: #{100 * index/total_search_space}\%"
    signal_fraction += 0.01
  end

  state = index.to_s(num_perms)
  state = '0' * (size/2 - 1 - state.length) + state
  state = state.split('').map {|c| c.to_i}

  string = perms[0] + perms[0].reverse
  state.each do |state_index|
    string << perms[state_index] + perms[state_index].reverse
  end

  if perm_check(string)
    puts "\n#{string}"
    output_file.write(string + "\n")
    output_file.flush
    return
  end

  if index % 1000 == 0
    print '.'
  end 
end