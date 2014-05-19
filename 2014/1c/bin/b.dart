import "dart:io";

log(s) {
//  print(s);
}

class CarLetter {
  String car;
  var index;
  get isHead => index == 0;
  get isTail => index == car.length - 1;
  CarLetter(this.car, this.index);
  toString() => "$car $index";
}

class LetterGraphNode {
  String letter;
  num cyclicWords = 0;
  var incoming = new Set<LetterGraphNode>();
  var outgoing = new Set<LetterGraphNode>();
  LetterGraphNode(String this.letter);
  toString() { return "$letter${outgoing.isNotEmpty?'->$outgoing':''}"; }
}

factorial(num n) {
  var fact = 1;
  for (var i = 1; i <= n; i++) {
    fact *= i;
  }
  return fact;
}

class LetterGraph {
  Set<LetterGraphNode> nodes =
      new Set<LetterGraphNode>();
  Map<String, LetterGraphNode> mapLetterToNode =
      new Map<String, LetterGraphNode>();
  
  LetterGraph(Map<String, List<CarLetter>> letters) {
    // create all LetterGraphNodes for all head or tail letters
    letters.forEach((letter, listCarLetters) {
      listCarLetters.forEach(
          (CarLetter carletter) {
            if (carletter.isHead || carletter.isTail) {
              mapLetterToNode.putIfAbsent(
                  letter, 
                  () {
                    var lgn = new LetterGraphNode(letter);
                    nodes.add(lgn);
                    return lgn;
                  });
            }
          });
    });
    // create edges between LetterGraphNodes based on 
    // head/tail letters used on cars 
    letters.forEach((String letter, List<CarLetter> list) {
        var lgn = mapLetterToNode[letter];
        list.forEach(
            (CarLetter carletter) {
              if (carletter.isHead) {
                var lastchar = carletter.car[carletter.car.length-1];
                if (mapLetterToNode.containsKey(lastchar)) {
                  var destination = mapLetterToNode[lastchar];
                  if (destination != lgn) {
                    if (lgn.outgoing.length > 0) {
                      nodes = null;
                      return;
                    }
                    lgn.outgoing.add(destination);
                    if (destination.incoming.length > 0) {
                      nodes = null;
                      return;
                    }
                    destination.incoming.add(lgn);
                  } else {
                    // cyclic word
                    lgn.cyclicWords++;
                  }
                }
              }
        });
        if (nodes == null) {
          return;
        }
    });
  }
  
  numberOfComponentsAndRepetitionFactor() {
    Set workingset = new Set();
    workingset.addAll(nodes);
    var components = 0;
    var repetitionFactor = 1;
    while (workingset.isNotEmpty) {
      LetterGraphNode node = null;
      try {
        node = workingset.firstWhere((node) => node.incoming.length == 0);
      } catch (StateError) { // got cycle: no element with zero incoming edges 
        return null;
      }
      List reachable = findAllReachable(node, []);
      if (reachable == null) {
        return null;
      }
      var rf = reachable.fold(1, (S, LetterGraphNode node) =>
          S * factorial(node.cyclicWords));
      repetitionFactor *= rf;
      workingset.removeAll(reachable);
      components++;
    }
    return [components, repetitionFactor];
  }
  
  findAllReachable(LetterGraphNode node, List reachable) {
    if (reachable != null) {
      if (reachable.contains(node)) {
        reachable = null; // got circular reference
      } else {
        reachable.add(node);
        for (var next in node.outgoing) {
          reachable = findAllReachable(next, reachable);
          if (reachable == null) {
            break;
          }
        }
      }
    }
    return reachable;
  }
  
  toString() { return "$nodes"; }
}

class Result {
  int count = 0;
}

tryOne(List cars, Set choice, List selection, Result result) {
  for (var index in choice) {
    var reducedChoice = new Set();
    reducedChoice.addAll(choice);
    reducedChoice.remove(index);
    List newSelection = new List.from(selection);
    newSelection.add(index);
    if (newSelection.length < cars.length) {
      tryOne(cars, reducedChoice, newSelection, result);
      if (result.count == null) {
        break;
      }
    } else {
      StringBuffer sb = new StringBuffer();
      for (var index in newSelection) {
        sb.write(cars[index]);
      }
      Set chars = new Set();
      var prevchar = "";
      var valid = true;
      for (var char in sb.toString().split("")) {
        if (prevchar != "" && char != prevchar) {
          if (chars.contains(char)) {
            valid = false;
            break;
          }
        }
        prevchar = char;
        chars.add(char);
      }
      if (valid) {
        result.count++;
      }
    }
  }
}

main() {
  var s = [
    '1',
    '2',
    'ab ab',
    '3',
    'ab bbbc cd',
    '4',
    'aa aa bc c',
    '2',
    'abc bcd',
];
//  var it = s.iterator; it.moveNext();
      
  File f = new File('B-large-practice (1).in');
  var it = f.readAsLinesSync().iterator..moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var t = 0; t < T; t++) {
    var N = int.parse(it.current); it.moveNext();
    var carsraw = it.current.split(" "); it.moveNext();
    var cars = [];
    for (var c in carsraw) {
      var newc = [];
      for (var ch in c.split('')) {
        if (newc.isEmpty 
            || newc.last != ch) { // compressing repeated characters
          newc.add(ch);
        }
      }
      cars.add(newc.join());
    }

    var count = 1;

    for (String car in cars) {
      if (car[0] == car[car.length-1] && car.length > 1) {
        count = null;
        break;
      }
    }

    var letters = new Map<String, List<CarLetter>>();
    
    if (count != null) {
      var set = new Set();
      set.addAll(new List.generate(N, (i) => i));
      var result = new Result();
//
//      bruteforce for debugging      
//      
//      tryOne(cars, set, [], result);
//      print(result.count);
      
      for (String car in cars) {
        for (var i = 0; i < car.length; i++) {
          var c = car[i];
          letters.putIfAbsent(c, () => []);
          letters[c].add(new CarLetter(car, i));
        }
      }
      log(letters);
      
      // validate mid-word characters show up only once
      for (var listCarLetters in letters.values) {
        var midCount = listCarLetters.fold(0, (count, CarLetter cl) =>
          count + (!cl.isHead && !cl.isTail? 1: 0));
        if (midCount > 0) {
          if (midCount > 1 || listCarLetters.length > 1) {
            count = null; // can't have same character in more than one CarLetter
            break;
          }
        }
      }
    }
    
    log(count);
    if (count != null) {

      var lettergraph = new LetterGraph(letters);
      log(lettergraph);
      if (lettergraph.nodes == null) {
        count = null;
      } else {
        for (LetterGraphNode node in lettergraph.nodes) {
          if (node.outgoing.length > 1 || node.incoming.length > 1) {
            count = null;
            break;
          }
        }
        if (count != null) {
          var candrf = lettergraph.numberOfComponentsAndRepetitionFactor();
          log(candrf);
        
          if (candrf == null) {
            count = null;
          } else {
            var components = candrf[0];
            var repetitionFactor = candrf[1];
            count = repetitionFactor * factorial(components);
            count = count % 1000000007; 
          }
        }
      }
      
      log(count);
    }
    print("Case #${t+1}: ${count == null? '0': count}");
  }
}