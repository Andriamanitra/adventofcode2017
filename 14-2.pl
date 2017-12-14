#!/usr/bin/perl
use 5.010;

# name of the day 10 part 2 solution executable which takes string as
# command line argument and outputs its knot hash to stdout
my $knothashFile = "knothash.exe";

open(DATA, "<14-input.txt") or die "Can't open the input file";
my $inputStr = <DATA>;
close(DATA);

my @matrix;
my $binaryString;
for ( $i = 0; $i < 128; $i += 1 ) {
    my $hash = qx/.\/$knothashFile $inputStr-$i/;
    $binaryString = "";
    foreach $char (split(//, $hash)) {
        $binaryString .= sprintf("%04b", oct("0x$char"));
    }
    my $j = 0;
    foreach $char (split(//, $binaryString)) {
        $matrix[$i][$j] = $char;
        $j += 1;
    }
}

sub deleteGroup {
    my $ref = shift;
    my $i = shift;
    my $j = shift;
    $$ref[$i][$j] = "0";
    if ($i+1 < 128 and $$ref[$i+1][$j] == "1") {
        deleteGroup(\@$ref, $i+1, $j);
    }
    if ($i-1 >= 0 and $$ref[$i-1][$j] == "1") {
        deleteGroup(\@$ref, $i-1, $j);
    }
    if ($j+1 < 128 and $$ref[$i][$j+1] == "1") {
        deleteGroup(\@$ref, $i, $j+1);
    }
    if ($j-1 >= 0 and $$ref[$i][$j-1] == "1") {
        deleteGroup(\@$ref, $i, $j-1);
    }
}

my $regions = 0;

for ( $i = 0; $i < 128; $i += 1 ) {
    for ( $j = 0; $j < 128; $j += 1 ) {
        if ($matrix[$i][$j] == "1") {
            $regions += 1;
            deleteGroup(\@matrix, $i, $j);
        }
    }
}

say("$regions regions found");
