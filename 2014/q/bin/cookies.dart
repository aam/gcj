import "dart:io";
import "package:intl/intl.dart";

void main() {
  File f = new File('B-large.in'); // 'B-small-attempt0.in'); // 'cookies.txt');
  var lines = f.readAsLinesSync();
  var T = int.parse(lines[0]);
  int lineNo = 1;
  
  var nf = new NumberFormat("################.#######");
  
  for (var test = 0; test < T; test++) {
    var L = lines[lineNo++].split(' ');
    var C = double.parse(L[0]);
    var F = double.parse(L[1]);
    var X = double.parse(L[2]);
    
    var result = 0;
    var prevSum = -1;
    var currentRate = 2.0;
    var secondsToBuildThisManyFarms = 0;
    while (true) {
      var secondsToGetToX = secondsToBuildThisManyFarms + X / currentRate;
      var secondsToBuildAnotherFarm = C / currentRate;

      if (prevSum > 0 && secondsToGetToX > prevSum) {
        result = prevSum;
        break;
      }
      prevSum = secondsToGetToX;
      
      secondsToBuildThisManyFarms += secondsToBuildAnotherFarm;
      currentRate += F;
    }
    
    print('Case #${test+1}: ${nf.format(result)}');
  }
}
