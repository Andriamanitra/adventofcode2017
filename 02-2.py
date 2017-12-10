with open("02-input.txt", "r") as f:
    data = f.read()

table = [[int(y) for y in x.split()] for x in data.splitlines()]

checksum = 0
for row in table:
    rsorted = sorted(row, reverse=True)
    for i in range(len(rsorted)-2):
        for j in range(i+1, len(rsorted)):
            if rsorted[i]%rsorted[j] == 0:
                print(rsorted[i], rsorted[j], rsorted[i]//rsorted[j])
                checksum += rsorted[i]//rsorted[j]


print("checksum:", checksum)
