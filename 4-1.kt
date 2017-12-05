import java.io.File

fun main(args: Array<String>) {
    val inputfile = File("4-input.txt")
    val text:List<String> = inputfile.bufferedReader().readLines()

    var valids = 0
    var total = 0
    for (line in text) {
        total += 1
        val splitted_line = line.split(" ")
        if (splitted_line.distinct().size == splitted_line.size) {
            valids += 1
        }
    }
    println("$valids/$total passphrases are valid")
}