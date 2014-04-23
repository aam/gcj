import "dart:io";
import "dart:math";

void printMap(String map, R, C) {
  for(var r = 0; r < R; r++) {
    print(map.substring(r*C, (r+1)*C));
  }
}

String fillRow(String map, R, C) {
  // find first empty row and fill it with mines
  var r = 0;
  while (r < R && map[r*C] == '*') r++;
  return map.substring(0, r*C) + ('*' * C) + map.substring((r+1)*C); 
}

String cutRow(String map, R, C) {
  return map.substring(C); 
}

String fillColumn(String map, R, C) {
  // find first empty column and fill it with mines
  StringBuffer sb = new StringBuffer();
  var c = 0;
  while (c < C && map[c] == '*') c++;
  for (var r = 0; r < R; r++) {
    sb.write(map.substring(r*C, r*C + c));
    sb.write('*');
    sb.write(map.substring(r*C + c + 1, (r+1)*C));
  }
  return sb.toString();
}

String cutColumn(String map, R, C) {
  StringBuffer sb = new StringBuffer();
  for (var r = 0; r < R; r++) {
    sb.write(map.substring(r*C + 1, (r+1)*C));
  }
  return sb.toString();
}

void main() {
  File f = new File('minesweeper.txt');
  var it = f.readAsLinesSync().iterator..moveNext();
  var T = int.parse(it.current);
  for (var i = 0; i < T  && it.moveNext(); i++) {
    var L = it.current.split(" ");
    var R = int.parse(L[0]);
    var C = int.parse(L[1]);
    var M = int.parse(L[2]);
    var map = "." * R*C;
    print("Case #$i:");
    print("\t${R} rows by ${C} columns with $M mines");
   
    var shortestDimension = min(R, C);
    while (M >= shortestDimension) {
      M -= shortestDimension;
      if (shortestDimension == R) {
        map = fillColumn(map, R, C);
//        printMap(map, R, C);
        map = cutColumn(map, R, C);
        C--;
      } else {
        map = fillRow(map, R, C);
//        printMap(map, R, C);
        map = cutRow(map, R, C);
        R--;
      }
      shortestDimension = min(R, C);
    }
    
    print("\tnow question is whether we can place $M mines on $R by $C map");
    printMap(map, R, C);
  }
}
