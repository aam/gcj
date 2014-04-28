import "dart:io";

depthFirst(N, depthFirstTraversal, Map edges, node, visited) {
  visited.add(node);
  var weAreAt = depthFirstTraversal.length; 
  depthFirstTraversal.add(node);
  List outgoings = edges[node];
  var childrenDeletes = [];
  var childrenTreeSizes = [];
  if (outgoings != null) {
    var lastChild = weAreAt + 1;
    for (var edgeTo in outgoings) {
      if (visited.contains(edgeTo)) {
        continue;
      }
      childrenDeletes.add(
          depthFirst(N, depthFirstTraversal, edges, edgeTo, visited));
      childrenTreeSizes.add(
          depthFirstTraversal.length - lastChild);
      lastChild = depthFirstTraversal.length;
    }
  }
  if (childrenDeletes.length > 0) {
    if (childrenDeletes.length == 1) {
      return childrenTreeSizes[0]; // deleting children
    } else {
      var cd = childrenDeletes.take(3).toList();
      var cts = childrenTreeSizes.take(3).toList();
      var dups = [0, 0, 0];
      if (cd.length > 2) {
        var cd0 = childrenDeletes[0];
        var cd1 = childrenDeletes[1];
        var cd2 = childrenDeletes[2];
        var cts0 = childrenTreeSizes[0];
        var cts1 = childrenTreeSizes[1];
        var cts2 = childrenTreeSizes[2];
        for (var i = 3; i < childrenDeletes.length; i++) {
          var cdi = childrenDeletes[i];
          var ctsi = childrenTreeSizes[i];
          if (cdi != cd0 || cdi != cd1 || cdi != cd2 ||
              ctsi != cts0 || ctsi != cts1 || ctsi != cts2) { 
            cd.add(cdi);
            cts.add(ctsi);
          } else {
            dups[0]++;
            dups[1]++;
            dups[2]++;
          }
        }
      }  
      var leastPenalty = -1;
      var children = cd.length;
      for (var i = 0; i < children - 1; i++) {
        for (var j = i + 1; j < children; j++) { 
          var penalty = cd[i] + cd[j];
          for (var k = 0; k < cd.length; k++) {
            if (k != i && k != j) {
              penalty += cts[k];
              if (k < 3) penalty += dups[k];
            }
          }
          if (leastPenalty < 0 || penalty < leastPenalty) {
            leastPenalty = penalty;
          }
        }
      }
      
      return leastPenalty;
    }
  }
  return 0;
}

spanningTree(N, head, Map edges) {
  return depthFirst(N, new List(), edges, head, new Set());
}

main() {
  File f = new File('B-large-practice.in'); //minesweeper.txt');
  var it = f.readAsLinesSync().iterator..moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var i = 0; i < T; i++) {
    var N = int.parse(it.current); it.moveNext();
    var edges = {};
    for (var j = 0; j < N - 1; j++) {
      var edge = it.current.split(" ").map((x) => int.parse(x) - 1).toList(); it.moveNext();
      var edge0 = edges.putIfAbsent(edge[0], () => new List());
      edge0.add(edge[1]);
      var edge1 = edges.putIfAbsent(edge[1], () => new List());
      edge1.add(edge[0]);
    }
    var mintodelete = -1;
    for (var head = 0; head < N; head++) {
      if (edges[head] != null) {
        var todelete = spanningTree(N, head, edges);
        if (mintodelete == -1 || todelete < mintodelete) {
          mintodelete = todelete;
        }
      }
    }
    print("Case #${i+1}: $mintodelete");
  }
}