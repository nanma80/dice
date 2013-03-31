require_relative 'lib/variance'
require_relative 'lib/all_perms'
require_relative 'lib/perm_check'

num_players = 5
size = 30
num_iter = 10

perms = all_perms(num_players)
num_perms = perms.length

# initialize to random state_arr: e.g., [0, 5, 2, 3, 1, 3]
state_arr = [0]
(size - 1).times do 
  state_arr << rand(num_perms)
end
# alternatively you may set the initial value
state_arr = [0, 114, 55, 63, 93, 103, 60, 85, 58, 98, 118, 27, 36, 23, 0, 83, 49, 100, 65, 102, 62, 56, 26, 18, 74, 107, 114, 66, 63, 13]

# convert state_arr to string
state_str = state_arr.map{|index| perms[index]}.join
state_score = score(state_str, num_players)
if state_score < 0.0000001
  p [state_str, state_score]
  return
end

best = [state_arr, state_str, state_score]

num_iter.times do 
  p [state_str, state_score]

  neighbors_arr = []
  neighbors_str = []
  neighbors_score = []

  (size - 1).times do |perm_position|
    (num_perms - 1).times do |perturb_offset|
      neighbor_state_arr = Array.new(state_arr)
      neighbor_state_arr[perm_position + 1] += perturb_offset
      neighbor_state_arr[perm_position + 1] %= num_perms
      neighbor_state_str = neighbor_state_arr.map{|index| perms[index]}.join
      neighbor_state_score = score(neighbor_state_str, num_players)

      if neighbor_state_score < 0.0000001
        puts 'A neighbor is optimal'
        p [neighbor_state_arr, neighbor_state_str, neighbor_state_score]
        output_file = File.open('output.txt', 'w')
        output_file.write(neighbor_state_str)
        return
      end

      if neighbor_state_score < best[2]
        best = [neighbor_state_arr, neighbor_state_str, neighbor_state_score]
      end

      neighbors_arr << neighbor_state_arr
      neighbors_str << neighbor_state_str
      neighbors_score << neighbor_state_score

    end
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

    state_arr = neighbors_arr[selected]
    state_score = neighbors_score[selected]
  end
end

puts "Cannot find permutation fair dice after #{num_iter} round of search. The best so far is:"
p best
output_file = File.open('output.txt', 'w')
output_file.write(best)
