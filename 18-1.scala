import scala.io.Source

val instructions = Source.fromFile("18-input.txt").getLines
    .map(_.split(" ")).toArray


var sounds:Map[String, Long] = Map()

def getFreq(s:String) : Long = {
    try {
        s.toLong
    } catch {
        case e: Exception => {
            sounds.getOrElse(s, 0)
        }
    }
}

def main() : Long = {
    var i = 0
    var last_played : Long = 0
    while ( i >= 0 ) {
        val instr = instructions(i)
        val param1 = instr(1)
        if (instr(0) == "snd") {
            last_played = getFreq(param1)
        } else if (instr(0) == "rcv") {
            if (getFreq(param1) != 0) {
                return last_played
            }
        } else {
            val param2 = instr(2)
            if (instr(0) == "set") {
                sounds = sounds + (param1 -> getFreq(param2))
            } else if (instr(0) == "add") {
                sounds = sounds + (param1 -> (sounds.getOrElse(param1, 0.toLong) + getFreq(param2)))
            } else if (instr(0) == "mul") {
                sounds = sounds + (param1 -> (sounds.getOrElse(param1, 0.toLong) * getFreq(param2)))
            } else if (instr(0) == "mod") {
                sounds = sounds + (param1 -> (sounds.getOrElse(param1, 0.toLong) % getFreq(param2)))
            } else if (instr(0) == "jgz") {
                if (getFreq(param1) > 0) {
                    // - 1 to offset the increment at the end of the loop
                    i = i + getFreq(param2).toInt - 1
                }
            }
        }
        i = i + 1
    }
    return 0
}

println("The frequency of last sound played was %d".format(main()))