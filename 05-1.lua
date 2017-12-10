containing_folder = string.match(arg[0], '.*\\')
file = io.open(containing_folder .. "05-input.txt")

arr = {}
while true do
    line = file:read()
    if line == nil then
        break
    end
    table.insert(arr, line)
end

i = 1
steps = 0
while i <= #arr and i > 0 do
    steps = steps + 1
    arr[i] = arr[i] + 1
    i = i + arr[i] - 1
end
print("steps taken: " .. steps)
print("current index: " .. math.floor(i))