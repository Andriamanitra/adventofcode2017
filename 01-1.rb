list = File.read("01-input.txt").split("")

sum = 0

for i in -1..list.length-2 do
    sum += list[i].to_i if list[i] == list[i+1]
end

puts sum