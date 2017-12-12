file := File with("12-input.txt")
lines := file readLines
file close

dict := Map clone
lines foreach(i, v,
    nums := v split(" <-> ")
    dict atPut(nums first, nums last split(", "))
)

start := "0"
set := Map clone
groupsize := 1
set atPut(start)
check := method(x,
    dict at(x) foreach(i, v,
        set hasKey(v) ifFalse(
            set atPut(v)
            groupsize = groupsize + 1
            check(v)
        )
    )
)

check(start)

groupsize println
