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
check := method(x,
    dict at(x) foreach(i, v,
        set hasKey(v) ifFalse(
            set atPut(v)
            check(v)
        )
    )
)

groups := 0
dict keys foreach(i, v,
    set hasKey(v) ifFalse(
        groups = groups + 1
        set atPut(v)
        check(v)
    )
)

groups println
