import "dart:io";

findSmallestThatGreaterThan(greaterThan, blocks) {
  var candidatekb = null;
  for (var kb in blocks.reversed) {
    if (kb > greaterThan) {
      // looking for smallest greater than chosen Naomis block
      candidatekb = kb;
    } else {
      break;
    }
  }
  return candidatekb;
}


kensMove(nb, kensBlocks) {
  var candidatekb = findSmallestThatGreaterThan(nb, kensBlocks);
  var score = 0;
  if (candidatekb == null) {
    candidatekb = kensBlocks.first; // can't beat Naomis selection, so chosing smallest
    score = 1;
  }
  kensBlocks.remove(candidatekb);
  return score;
}

void main() {
  File f = new File('D-large-practice.in');
  var it = f.readAsLinesSync().iterator..moveNext();
//  
//  var testinput =[
//    "4",
//    "1",
//    "0.5",
//    "0.6",
//    "2",
//    "0.7 0.2",
//    "0.8 0.3",
//    "3",
//    "0.5 0.1 0.9",
//    "0.6 0.4 0.3",
//    "9",
//    "0.186 0.389 0.907 0.832 0.959 0.557 0.300 0.992 0.899",
//    "0.916 0.728 0.271 0.520 0.700 0.521 0.215 0.341 0.458"];
//  
//  var it = testinput.iterator..moveNext();
  var T = int.parse(it.current);
  for (var i = 0; i < T  && it.moveNext(); i++) {
    var N = it.current; it.moveNext();
    List naomisBlocks = it.current.split(" ").map((x) => double.parse(x)).toList()..sort();
    it.moveNext();
    List kensBlocks = it.current.split(" ").map((x) => double.parse(x)).toList()..sort();
//    print("Case #${i+1} started");
//    print("\t$N, $naomisBlocks, $kensBlocks");
    
    var naomisScore = 0;
    var kBs = new List.from(kensBlocks);
    for (var nb in naomisBlocks) {
      naomisScore += kensMove(nb, kBs);
    }
    
    var naomisDeceitfulScore = 0;
    while (naomisBlocks.length > 0) {
      var nb = naomisBlocks.last;
      var kb = findSmallestThatGreaterThan(nb, kensBlocks);
      if (kb == null) {
        kb = kensBlocks.first;
      }
      nb = findSmallestThatGreaterThan(kb, naomisBlocks);
      if (nb == null) {
        nb = naomisBlocks.first;
      }
      naomisDeceitfulScore += nb > kb? 1: 0;
      kensBlocks.remove(kb);
      naomisBlocks.remove(nb);
    }
    
    print("Case #${i+1}: $naomisDeceitfulScore $naomisScore");
  }
}
