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

proc dance {programs instructions times} {
    for {set index 0} {$index < $times} {incr index} {
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
    }
    return $programs
}

proc dance_until_repetition {programs instructions} {
    set beentheres {}
    lappend beentheres [join $programs ""]
    set index 1
    while {1} {
        set programs [dance $programs $instructions 1]
        set beenthere [join $programs ""]
        set lasthere [lsearch $beentheres $beenthere]
        if {$lasthere > -1} {
            return $beentheres
        }
        lappend beentheres $beenthere
        incr index
    }
}


set danceresults [dance_until_repetition $programs $instructions]
set period [llength $danceresults]
set answer [lindex $danceresults [expr { 1000000000 % $period }]]
puts "Program order after dancing a billion dances:"
puts $answer
