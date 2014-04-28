import "dart:io";
import "dart:math";

countbits(x) {
  var n = 0;
  while (x > 0) {
    x = x & ~(x ^ (x - 1));
    n++;
  }
  return n;
}

void main() {
  File f = new File('A-large.in'); //minesweeper.txt');
  var it = f.readAsLinesSync().iterator..moveNext();
  var tests = [
      "3",
      "3 2",
      "01 11 10",
      "11 00 10",
      "2 40",
      "101 111",
      "010 001",
      "2 2",
      "01 10",
      "10 01"];
//  var it = tests.iterator..moveNext();
  var T = int.parse(it.current);
  for (var i = 0; i < T  && it.moveNext(); i++) {
    var l = it.current.split(" "); it.moveNext();
    var N = int.parse(l[0]);
    var L = int.parse(l[1]);
    print(it.current);
    List outlets = new List.from(it.current.split(" ").map((x) { print(x); return int.parse(x, radix: 2); }));
    it.moveNext();
    var devices = new Set();
    print(it.current);
    devices.addAll(it.current.split(" ").map((x) => int.parse(x, radix: 2)));
    
//    print("Case ${i+1} N=$N L=$L, outlets=$outlets, devices=$devices");

    var tryFlippingTheseSwitches = [];
    var impossible = false;
    for (var b = 0; b < L; b++) {
      var bitvalue = 1 << b;
      var devicesWithB = devices.fold(
          0, 
          (sum, device) => (device & bitvalue) != 0? sum + 1: sum);
      var outletsWithB = outlets.fold(
          0, 
          (sum, outlet) => (outlet & bitvalue) != 0? sum + 1: sum);
      
      if (devicesWithB != outletsWithB && 
         devicesWithB != (N - outletsWithB)) {
        impossible = true;
        break;
      }
      if (devicesWithB == N - outletsWithB) {
        tryFlippingTheseSwitches.add(b);
      }
    }
    
    var minflips = null;
    if (!impossible) {
      var len = tryFlippingTheseSwitches.length;
      for (var c = 0; c < 1 << len; c++) {
        var b = 0; // calculate new flipping mask
        for (var j = 0; j < len; j++) {
          if (c & (1 << j) != 0) {
            // time to flip jth switch
            b |= 1 << tryFlippingTheseSwitches[j];
          }
        }
//        print(b);
        var newoutlets = new Set();
        for (var o in outlets) {
          newoutlets.add(o ^ b);
        }
  //      print("$newoutlets");
        if (newoutlets.containsAll(devices)) {
          var flips = countbits(b);
          if (minflips == null || flips < minflips) {
            minflips = flips;
            if (minflips == 0) {
              break;
            }
          }
  //        print("found $b");
        }
      }
    }
    
    print("Case #${i+1}: ${minflips != null? minflips: 'NOT POSSIBLE'}");
  }
}
