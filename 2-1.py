with open("2-input.txt", "r") as f:
    data = f.read()

table = []
rows = data.split("\n")
for r in rows:
    rstr = r.split()
    rint = [int(x) for x in rstr]
    table.append(rint)

checksum = 0
for row in table:
    checksum += max(row)-min(row)
print(checksum)