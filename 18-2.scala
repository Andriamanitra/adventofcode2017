// DOES NOT WORK YET, NEEDS QUEUEUEUEUES FOR WHEN BOTH ARE SENDING!

import scala.io.Source

val instructions = Source.fromFile("18-input.txt").getLines
    .map(_.split(" ")).toArray


type Registers = Map[String, Int]

def getFreq(regs:Registers, s:String) : Int = {
    try {
        s.toInt
    } catch {
        case e: NumberFormatException => {
            regs.getOrElse(s, 0)
        }
    }
}

def exec_until_block(regz:Registers, j:Int) : (Registers, Int) = {
    var regs = regz
    var i = j
    while ( i >= 0 ) {
        val instr = instructions(i)
        val param1 = instr(1)
        if (instr(0) == "snd" || instr(0) == "rcv") {
            return (regs, i)
        } else {
            val param2 = instr(2)
            if (instr(0) == "set") {
                regs = regs + (param1 -> getFreq(regs, param2))
            } else if (instr(0) == "add") {
                regs = regs + (param1 -> (regs.getOrElse(param1, 0.toInt) + getFreq(regs, param2)))
            } else if (instr(0) == "mul") {
                regs = regs + (param1 -> (regs.getOrElse(param1, 0.toInt) * getFreq(regs, param2)))
            } else if (instr(0) == "mod") {
                regs = regs + (param1 -> (regs.getOrElse(param1, 0.toInt) % getFreq(regs, param2)))
            } else if (instr(0) == "jgz") {
                if (getFreq(regs, param1) > 0) {
                    // - 1 to offset the increment at the end of the loop
                    i = i + getFreq(regs, param2).toInt - 1
                }
            }
        }
        i = i + 1
    }
    return (regs, i)
}

def main() : Int = {
    var regs1:Registers = Map("p" -> 0)
    var ip1 = 0
    var regs2:Registers = Map("p" -> 1)
    var ip2 = 0

    var result = 0

    while (true) {
        var state1:(Registers, Int) = exec_until_block(regs1, ip1)
        regs1 = state1._1
        ip1 = state1._2
        var state2:(Registers, Int) = exec_until_block(regs2, ip2)
        regs2 = state2._1
        ip2 = state2._2
        val instr1 = instructions(ip1)
        val instr2 = instructions(ip2)
        if (instr1(0) == "snd") {
            result = result + 1
            if (instr2(0) == "rcv") {
                regs2 = regs2 + (instr2(1) -> getFreq(regs1, instr1(1)))
            } else {
                // both sending.. the values should be put in a list or something
                println("we have problems")
                return result
            }
        } else if (instr2(0) == "snd") {
            regs1 = regs1 + (instr1(1) -> getFreq(regs2, instr2(1)))
        } else {
            // both receiving
            return result
        }
        ip1 = ip1 + 1
        ip2 = ip2 + 1
    }

    return result
}

println("The first program sent %d times".format(main()))