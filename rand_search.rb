require_relative 'lib/all_perms'
require_relative 'lib/perm_check'

num_players = 5
size = 30
num_iter = 100
neighbor_distance = 1

perms = all_perms(num_players)
num_perms = perms.length

# initialize to random state_arr: e.g., [0, 5, 2, 3, 1, 3]
state_arr = [0]
(size - 1).times do 
  state_arr << rand(num_perms)
end
# alternatively you may set the initial value
# state_arr = [0, 23, 14, 21, 19, 0, 18, 14, 9, 5, 3, 11]

# convert state_arr to string
state_str = state_arr.map{|index| perms[index]}.join
state_score = score(state_str, num_players)
if state_score < 0.0000001
  p [state_str, state_score]
  return
end

best = [state_arr, state_str, state_score]

num_iter.times do |iter_index|
  num_neighbors = (10 * (iter_index + 1) ** 0.5).to_i

  p [state_str, state_score]

  neighbors_arr = []
  neighbors_str = []
  neighbors_score = []

  num_neighbors.times do 
    neighbor_state_arr = Array.new(state_arr)

    while neighbor_state_arr == state_arr
      neighbor_distance.times do 
        rand_pos = rand(size - 1) + 1
        neighbor_state_arr[rand_pos] += rand(num_perms - 1) + 1
        neighbor_state_arr[rand_pos] %= num_perms
      end
    end

    neighbor_state_str = neighbor_state_arr.map{|index| perms[index]}.join
    neighbor_state_score = score(neighbor_state_str, num_players)

    if neighbor_state_score < 0.0000001
      puts 'A neighbor is optimal'
      p [neighbor_state_arr, neighbor_state_str, neighbor_state_score]
      output_file = File.open('permutation_fair.txt', 'w')
      output_file.write(neighbor_state_str)
      return
    end

    if neighbor_state_score < best[2]
      best = [neighbor_state_arr, neighbor_state_str, neighbor_state_score]
      output_file = File.open('best_so_far.txt', 'w')
      output_file.write(best)
      output_file.flush
    end

    neighbors_arr << neighbor_state_arr
    neighbors_str << neighbor_state_str
    neighbors_score << neighbor_state_score
  end

  if neighbors_score.min < state_score
    selected = 0
    min_so_far = neighbors_score[0]
    best_arr_so_far = neighbors_arr[0]
    search_space = neighbors_score.length - 1

    search_space.times do |search_index|
      if neighbors_score[search_index + 1] < min_so_far
        min_so_far = neighbors_score[search_index + 1]
        best_arr_so_far = neighbors_arr[search_index + 1]
      end
    end

    state_score = min_so_far
    state_arr = best_arr_so_far 
  else
    puts 'Jumping out of local minimum'

    bins = [0]
    neighbors_score.each do |score|
      bins << bins.last + 1 / (score ** 3)
    end
    rand_num = rand() * bins.last

    selected = nil
    (bins.length - 1).times do |bin_index|
      if (bins[bin_index + 1] > rand_num)
        selected = bin_index
        break
      end
    end
    selected ||= 0
    # puts "before"
    # p state_arr
    # puts "after"
    state_arr = neighbors_arr[selected]
    state_score = neighbors_score[selected]
    
  end
end

puts "Cannot find permutation fair dice after #{num_iter} round of search. The best so far is:"
p best
output_file = File.open('best_so_far.txt', 'w')
output_file.write(best)
