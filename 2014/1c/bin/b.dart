import "dart:io";

log(s) {
  print(s);
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
  var incoming = new Set<LetterGraphNode>();
  var outgoing = new Set<LetterGraphNode>();
  LetterGraphNode(String this.letter);
  toString() { return "$letter${outgoing.isNotEmpty?'->$outgoing':''}"; }
}

class LetterGraph {
  var nodes;
  var mapLetterToNode;
  LetterGraph(Map<String, List<CarLetter>> letters) {
    nodes = new Set<LetterGraphNode>();
    mapLetterToNode = new Map<String, LetterGraphNode>();
    letters.forEach((letter, list) {
        list.forEach((CarLetter carletter) {
            if (carletter.isHead) {// || carletter.isTail) {
              var lgn = new LetterGraphNode(letter);
              nodes.add(lgn);
              mapLetterToNode.putIfAbsent(letter, () => lgn);
            };
        });
    });
    letters.forEach((letter, list) {
        var lgn = mapLetterToNode[letter];
        list.forEach((CarLetter carletter) {
          if (carletter.isHead) {
            var lastchar = carletter.car[carletter.car.length-1];
            if (mapLetterToNode.containsKey(lastchar)) {
              var destination = mapLetterToNode[lastchar];
              if (destination != lgn) {
                lgn.outgoing.add(destination);
                destination.incoming.add(lgn);
              }
            }
          }
        }); 
    });
  }
  
  numberOfComponents() {
    Set workingset = new Set();
    workingset.addAll(nodes);
    var components = 0; 
    while (workingset.isNotEmpty) {
      LetterGraphNode node = workingset.first;
      var reachable = findAllReachable(node, []);
      if (reachable == null) {
        return null;
      }
      workingset.removeAll(reachable);
      components++;
    }
    return components;
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

main() {
  var s = [
    '1',
    '4',
    'a cd abc',
    '2',
    'vvvvvvvvvvvvvbbbbbbbbbbbbbbbbbbsssssssssssssfffffffffppppppppppppppplllllllllllllllll ttttzzzzzzzzzyyyyyaaaaooooooiiiiiiiiiinnnjjjjjjjjmmmmdddddddgggcccccxxxxxeeeeeeeeeeqqqqqhhhhrrrrrr',
    '5',
    'xx fffffrrrrrrrrrrrr xssssttwwwf rrr ffffffffff',
    '3',
    'ab bbbc cd',
    '8',
    'iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj qqqqqqqqqqqqqnnnnnnnnnnnnnnnnnnnnnnnnnlllllllllllllllhhhhhhhhhhhhhhhhhh ssssvxxxxbbb uuuuuuuuuuuuuuuuuutttttttttttttttttttttttttffffffffffffffffffffffffffffff uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu gggwwwwwwwrrrrrraaaaoooooooppppppyyyyyyyeeeeeeeccccccccccdddddddmmmmmmmzzzzzzkkkk uuuuuuuuuuuuuuuuuuuuuuuuuuuuu',
    '4',
    'aa aa bc c',
    '2',
    'abc bcd',
];
  var it = s.iterator; it.moveNext();
      
  File f = new File('B-small-practice (2).in');
//  var it = f.readAsLinesSync().iterator..moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var t = 0; t < T; t++) {
    var N = int.parse(it.current); it.moveNext();
    var carsraw = it.current.split(" "); it.moveNext();
    var cars = [];
    for (var c in carsraw) {
      var newc = [];
      for (var ch in c.split('')) {
        if (newc.isEmpty || newc.last != ch) {
          newc.add(ch);
        }
      }
      cars.add(newc.join());
    }
    var carsset = new Set();
    carsset.addAll(cars);
    var factor = 1 << (cars.length - carsset.length);
    
    var letters = new Map<String, List<CarLetter>>();
    var count = factor;
    for (String car in carsset) {
      for (var i = 0; i < car.length; i++) {
        var c = car[i];
        var head = i == 0;
        var tail = i == car.length - 1;
        if (tail && (i != car.length - 1)) continue;
        if (letters.containsKey(c)) {
          if (!head && !tail) {
            for (CarLetter cl in letters[c]) {
              if (cl.car != car) {
                count = null; // can be only one char with this car inside
                break;
              } else {
                var mid = cl.index;
                if (car.substring(mid, i) != (c * (i - mid))) {
                  count = null; // has to be contiguous section
                  break;
                }
              }
            }
            if (count != null) {
              continue; // skip mid repetition of character
            } else {
              // can't build good set
              break;
            }
          }
          if (head && !tail) {
            for (CarLetter cl in letters[c]) {
              if (cl.car != car && !cl.isTail) {
                // can't build good set
                count = null;
                break;
              }
            }
          } else if (!head && tail) {
            for (CarLetter cl in letters[c]) {
              if (cl.car != car && !cl.isHead) {
                // can't build good set
                count = null;
                break;
              }
            }
          } else {
            // head and tail
            for (CarLetter cl in letters[c]) {
              if (cl.car != car && !(cl.isHead || cl.isTail)) {
                // can't build good set
                count = null;
                break;
              }
            }
          }
        } else {
          letters.putIfAbsent(c, () => []);
        }
        letters[c].add(new CarLetter(car, i));
      }
      if (count == null) {
        break;
      }
    }
    log(letters);
    log(count);
    if (count != null) {

      var lettergraph = new LetterGraph(letters);
      log(lettergraph);
      var components = lettergraph.numberOfComponents();
      log(components);
      
//      var carssetOccurrences = {};
//      for (var c in cars) {
//        carssetOccurrences.putIfAbsent(c, () => 0);
//      }
//      var freeCars = new List.from(cars);
//      for (var char in letters.keys) {
//        var nHeads = 0;
//        var nTails = 0;
//        for (var cl in letters[char]) {
//          if (cl.isHead) {
//            nHeads++;
//          }
//          if (cl.isTail){
//            nTails++;
//          }
//        }
//        if (nHeads > 0 && nTails > 0) {
//          // all words with char as head is bound 
//          // to all words with char as tail
//          for (var cl in letters[char]) {
//            if (cl.isHead) {
//              heads.add(cl.car);
//              freeCars.remove(cl.car);
//            }
//            if (cl.isTail){
//              tails.add(cl.car);
//              freeCars.remove(cl.car);
//            }
//          }
//        }
//      }
//      for (var bc in boundCars) {
//        freeCars.remove(bc);
//      }
//      
//      var cnt = freeCars.length;
//      for (var char in letters.keys) {
//        var nHeads = 0;
//        var nTails = 0;
//        for (var cl in letters[char]) {
//          if (boundCars.contains(cl.car)) {
//            if (cl.isHead) {
//              nHeads++;
//            }
//            if (cl.isTail){
//              nTails++;
//            }
//          }
//        }
//        cnt += (nHeads * nTails);
//      }
//      while (cnt > 0) {
//        count *= cnt;
//        cnt--;
//      }

      if (components == null) {
        count = null;
      } else {
        while (components > 0) {
          count *= components;
          components--;
        }
      }
      
      log(count);
    }
    print("Case #${t+1}: ${count == null? '0': count}");
  }
}