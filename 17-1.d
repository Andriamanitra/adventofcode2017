module main;

void main(string[] args) {
    import std.stdio;
    import std.conv;
    import std.array;
    auto file = File("17-input.txt");
    immutable int step = to!int(file.readln());
    writefln("Using step size %d", step);
    
    int until = 2017;
    int[] numbers = [0, 1];
    int curr = 1;
    for (int to_add = 2; to_add <= until; to_add++) {
        curr = (curr + step + 1) % numbers.length;
        numbers.insertInPlace(curr, to_add);
    }
    int answer = numbers[(curr + 1) % numbers.length];
    writefln("The number directly after %d is %d", until, answer);
}
