import "dart:io";
import "dart:math";

void printMap(String map, R, C) {
  for(var r = 0; r < R; r++) {
    print(map.substring(r*C, (r+1)*C));
  }
}

String fillRow(String map, left, top, R, C, {mines: -1}) {
  if (mines == -1) {
    mines = C - left; // by default we are filling whole row 
  }
  // find first empty row and fill it with mines
  var r = top;
  while (r < R && map[r*C + left] == '*') r++;
  return map.substring(0, r*C + left) 
      + ('*' * mines)
      + map.substring(r*C + left + mines); 
}

String fillColumn(String map, left, top, R, C, {mines: -1}) {
  if (mines == -1) {
    mines = R - top; // by default we are filling whole column 
  }
  // find first empty column and fill it with mines
  StringBuffer sb = new StringBuffer();
  var c = left;
  while (c < C && map[top*C + c] == '*') c++;
  sb.write(map.substring(0, top*C));
  for (var r = top; r < R; r++) {
    sb.write(map.substring(r*C, r*C + c));
    if (r < mines + top) {
      sb.write('*');
    } else {
      sb.write('.');
    }
    sb.write(map.substring(r*C + c + 1, (r+1)*C));
  }
  return sb.toString();
}

void main() {
  File f = new File('C-large-practice.in'); //C-small-attempt0.in'); //minesweeper.txt');
  var it = f.readAsLinesSync().iterator..moveNext();
//  var tests = ["1", "4 5 13", "5 4 7", "4 3 11", "5 2 4"];
//  var it = tests.iterator..moveNext();
  var T = int.parse(it.current);
  for (var i = 0; i < T  && it.moveNext(); i++) {
    var L = it.current.split(" ");
    var R = int.parse(L[0]);
    var C = int.parse(L[1]);
    var M = int.parse(L[2]);
    var map = "." * R*C;
    print("Case #${i+1}: ");
//    print("\t${R} rows by ${C} columns with $M mines");
   
    var shortestDimension = min(R, C);
    var left = 0;
    var top = 0;
    while (M >= shortestDimension) {
      M -= shortestDimension;
      if (shortestDimension == (R - top)) {
        map = fillColumn(map, left, top, R, C);
        left++;
      } else {
        map = fillRow(map, left, top, R, C);
        top++;
      }
      shortestDimension = min(R - top, C - left);
//      printMap(map, R, C);
    }
    var remR = R - top;
    var remC = C - left;
    
//    print("\tnow question is whether we can place $M mines on $remR by $remC map");
    
    if (remR == 1 || remC == 1) {
      if (remR == 1 && remC == 1 && M == 0) {
      } else if (remR == 1 && R > 1 || remC == 1 && C > 1)
        map = null;
    } else if (remR == 2 || remC == 2) {
        if (M > 0) {      
          map = null;
        }
    } else { //    if (remR > 2 || remC > 2) {
      while (M > 0) {
        if (remC > remR) {
          var minesToPlaceOnThisRow = min(M, remC - 2);
          if (minesToPlaceOnThisRow == 0) { 
            map = null;
            break;
          }
          map = fillRow(map, left, top, R, C, mines: minesToPlaceOnThisRow);
          top++;
          M -= minesToPlaceOnThisRow;
        } else {
          var minesToPlaceInThisColumn = min(M, remR - 2);
          if (minesToPlaceInThisColumn == 0) { 
            map = null;
            break;
          }
          map = fillColumn(map, left, top, R, C, mines: minesToPlaceInThisColumn);
          left++;
          M -= minesToPlaceInThisColumn;
        }
        remR = R - top;
        remC = C - left;
        if (remR == 2 || remC == 2) {
          if (M > 0) {      
            map = null;
            break;
          }
        }
      }
    }
    
    if (map != null) {
      map = map.substring(0, map.length - 1) + 'c';
      printMap(map, R, C);
    } else {
      print("Impossible");
    }
  }
}
