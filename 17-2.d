module main;

void main(string[] args) {
    import std.stdio;
    import std.conv;
    import std.array;
    auto file = File("17-input.txt");
    immutable int step = to!int(file.readln());
    writefln("Using step size %d", step);
    
    int until = 50_000_000;
    int index_of_zero = 0;
    int after_zero = 1;
    int length_of_array = 2;
    int curr = 1;
    for (int to_add = 2; to_add <= until; to_add++) {
        curr = (curr + step + 1) % length_of_array;
        if (curr == index_of_zero+1) {
            after_zero = to_add;
        }
        if (curr <= index_of_zero) {
            index_of_zero++;
        }
        length_of_array++;
    };
    writefln("The number directly after 0 is %d", after_zero);
}
