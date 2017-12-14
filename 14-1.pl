#!/usr/bin/perl

# name of the day 10 part 2 solution executable which takes string as
# command line argument and outputs its knot hash to stdout
$knothashFile = "knothash.exe";

open(DATA, "<14-input.txt") or die "Can't open the input file";
$inputStr = <DATA>;
close(DATA);

for ( $i = 0; $i < 128; $i = $i + 1 ) {
    $hash = qx/.\/$knothashFile $inputStr-$i/;
    foreach $char (split(//, $hash)) {
        $count = $count + sprintf("%b", oct("0x$char")) =~ tr/1//;
    }
}
print "Total number of ones in binary representations of hashes: $count\n";
