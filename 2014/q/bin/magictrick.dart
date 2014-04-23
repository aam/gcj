import "dart:io";

void main() {
  File f = new File('A-small-attempt0.in');
  var lines = f.readAsLinesSync();
  var T = int.parse(lines[0]);
  int lineNo = 1;
  for (var test = 0; test < T; test++) {
    var first = [];
    var firstChoice = int.parse(lines[lineNo++]);
    for (var l = 0; l < 4; l++) {
      first.add(lines[lineNo++].split(" "));
    }
    var secondChoice = int.parse(lines[lineNo++]);
    var second = [];    
    for (var l = 0; l < 4; l++) {
      second.add(lines[lineNo++].split(" "));
    }
//    print("first: $first, $firstChoice, second: $second, $secondChoice");
    
    var intersection = new Set.from(first[firstChoice - 1]).intersection(
        new Set.from(second[secondChoice - 1]));
    var verdict = 
        intersection.length == 0? "Volunteer cheated!":
          intersection.length == 1? intersection.first:
            "Bad magician!";
    print('Case #${test+1}: $verdict');
  }
}
