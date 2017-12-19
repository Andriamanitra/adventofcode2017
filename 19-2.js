fs = require('fs');

function printAnswer(steps) {
    console.log("Navigated through the maze in "+steps+" steps!");
}

fs.readFile("19-input.txt", "utf8", function (err, data) {
    const maze = {
        'matrix': data.split("\n").map(x => x.split("")),
        'height': function() { return this.matrix.length-1 },
        'width': function() { return this.matrix[0].length-1 },
        'at': function (p) {
            if (p.y > this.height || p.y < 0 || p.x > this.width || p.x < 0) {
                return "END";
            }
            return this.matrix[p.y][p.x];
        }
    }
    
    var up = function (p) { return { "x": p.x, "y": p.y-1 } },
    down   = function (p) { return { "x": p.x, "y": p.y+1 } },
    left   = function (p) { return { "x": p.x-1, "y": p.y } },
    right  = function (p) { return { "x": p.x+1, "y": p.y } };

    var steps = 1;
    var mazeChars = "|+-"

    // Find the starting point
    var p = {"x": 0, "y": 0}, direction = down;
    while (maze.at(p) != '|') {
        p = right(p);
    }

    // Navigate through the maze
    while (1) {
        // Walk in current direction until we must turn
        while (maze.at(direction(p)) != ' ') {
            p = direction(p);
            steps += 1;
            if (maze.at(direction(p)) == "END") {
                printAnswer(steps);
                return;
            }
            if ( !(mazeChars.includes( maze.at(p) ) )) {
                console.log("Found letter "+maze.at(p)+"!");
            }
        }

        // Turning
        if (direction == up || direction == down) {
            // See if it's possible to turn left or right
            if (maze.at(left(p)) == '-') {
                direction = left;
            } else if (maze.at(right(p)) == '-') {
                direction = right;
            } else { // Nowhere else to go, must be at the end of maze
                printAnswer(steps);
                return;
            }
        } else if (direction == left || direction == right) {
            // See if it's possible to turn up or down
            if (maze.at(up(p)) == '|') {
                direction = up;
            } else if (maze.at(down(p)) == '|' ) {
                direction = down;
            } else { // Nowhere else to go, must be at the end of maze
                printAnswer(steps);
                return;
            }
        }
    }
});