import 'dart:io';
import 'dart:math';


int walk(List path) {
  int x = 0;
  int y = 0;
  int max_dist = 0;
  for (var direction in path) {
    switch (direction) {
      case "n":
        y += 1;
        break;
      case "ne":
        y += 1;
        x += 1;
        break;
      case "se":
        x += 1;
        break;
      case "s":
        y -= 1;
        break;
      case "sw":
        x -= 1;
        y -= 1;
        break;
      case "nw":
        x -= 1;
        break;
      default:
        print("Unable to parse direction: "+direction);
    }
    max_dist = max(max_dist, dist_home_from(x, y));
  }
  print("Walked to ($x,$y)");
  return max_dist;
}

int dist_home_from(int x, int y) {
  return x.abs() + y.abs() - ( (x+y).abs()-max( x.abs(), y.abs() ) );
}

void main() {
  var input;
  input = new File('11-input.txt');
  input.readAsString().then((input_string) {
    var path = input_string.trim().split(",");
    var dist = walk(path);
    print("Max distance to home during journey: $dist");
  });
}
