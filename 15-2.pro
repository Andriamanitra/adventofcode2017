:- initialization main.

generator_a(Previous, X) :-
    Y is mod(Previous * 16807, 2147483647),
    Mod4 is mod(Y, 4),
    ( Mod4 == 0 -> X = Y ; generator_a(Y, X) ).

generator_b(Previous, X) :-
    Y is mod(Previous * 48271, 2147483647),
    Mod8 is mod(Y, 8),
    ( Mod8 == 0 -> X = Y ; generator_b(Y, X) ).

last_bits_match(X, Y, Matched) :-
    ModX is mod(X, 2**16),
    ModY is mod(Y, 2**16),
    ( ModX == ModY -> Matched = 1 ; Matched = 0 ).
    
calculate(0, _, _, Acc, Y) :-
    Y = Acc.
calculate(Counter, PrevA, PrevB, Acc, Y) :-
    generator_a(PrevA, A),
    generator_b(PrevB, B),
    last_bits_match(A, B, Matched),
    MinusOne is Counter - 1,
    NewAcc is Acc+Matched,
    calculate(MinusOne, A, B, NewAcc, Y).

main :-
    read_file_to_string("15-input.txt", InputString, []),
    writeln(InputString),
    split_string(InputString, " \n", "", L),
    nth0(4, L, A0str),
    nth0(9, L, B0str),
    atom_number(A0str, A0),
    atom_number(B0str, B0),
    calculate(5000000, A0, B0, 0, Result),
    format("Judge's final count is ~w", [Result]),
    halt.
    