# IMPORTANT: nim won't let you run a file with name "20-1.nim"
# because it's not a valid module name, so this file needs to
# be renamed before compiling!

import strutils
import strscans
import math
import std/enumerate


type
    point = tuple
        px, py, pz: int
        vx, vy, vz: int
        ax, ay, az: int

proc acceleration(p: point): float =
    result = sqrt((p.ax*p.ax + p.ay*p.ay + p.az*p.az).float)


let input = readFile("20-input.txt")

var points: seq[point]

for line in input.split("\n"):
    var px, py, pz, vx, vy, vz, ax, ay, az: int
    if scanf(line, "p=<$i,$i,$i>, v=<$i,$i,$i>, a=<$i,$i,$i>",
             px, py, pz, vx, vy, vz, ax, ay, az):
        points.add((px, py, pz, vx, vy, vz, ax, ay, az))

var min = 0
for i, p in enumerate(points):
    if acceleration(p) < acceleration(points[min]):
        min = i

echo "Particle at index ", min, " stays the closest to the origin"
