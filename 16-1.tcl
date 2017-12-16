set inputfile [open "16-input.txt" r]
gets $inputfile inputstring
close $inputfile

set instructions [split $inputstring ,]
set programs {a b c d e f g h i j k l m n o p}

proc lswap {list i j} {
    set temp [lindex $list $i]
    lset list $i [lindex $list $j]
    lset list $j $temp
    return $list
}

proc dance {programs instructions} {
    foreach instruction $instructions {
        if {[scan $instruction "s%d" spin] == 1} then {
            # spin
            set programs [concat [lrange $programs end-[expr $spin-1] end] [lrange $programs 0 end-$spin]]
        } elseif {[scan $instruction "x%d/%d" index1 index2] == 2} {
            # exchange
            set programs [lswap $programs $index1 $index2]
        } elseif {[scan $instruction "p%1s/%1s" name1 name2] == 2 } {
            # swap
            set index1 [lsearch $programs $name1]
            set index2 [lsearch $programs $name2]
            set programs [lswap $programs $index1 $index2]
        } else {
            puts [format "Invalid instruction: %s" $instruction]
        }
    }
    return $programs
}

puts "Program order after dancing:"
set programs [dance $programs $instructions]
puts [join $programs ""]
