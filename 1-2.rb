list = File.read("1-input.txt").split("")

sum = 0
halfway = list.length/2

for i in 0...list.length do
    sum += list[i].to_i if list[i] == list[(i+halfway)%list.length]
end

puts sum