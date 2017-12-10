import java.io.File

fun main(args: Array<String>) {
    val inputfile = File("04-input.txt")
    val text:List<String> = inputfile.bufferedReader().readLines()

    var valids = 0
    var total = 0
    for (line in text) {
        total += 1
        val splitted_line = line.split(" ")
        val arranged = splitted_line.map { s -> s.split("").sorted().joinToString() }
        if (arranged.distinct().size == arranged.size) {
            valids += 1
        }
    }
    println("$valids/$total passphrases are valid")
}