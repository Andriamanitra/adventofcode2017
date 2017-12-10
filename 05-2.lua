containing_folder = string.match(arg[0], '.*\\')
file = io.open(containing_folder .. "5-input.txt")

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
    if tonumber(arr[i]) >= 3 then
        change = -1
    else
        change = 1
    end
    arr[i] = arr[i] + change
    i = i + arr[i] - change
end
print("steps taken: " .. steps)
print("current index: " .. math.floor(i))