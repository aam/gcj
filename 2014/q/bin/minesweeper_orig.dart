import "dart:io";

rangeCheck(matrix, R, C, rowN, columnN,  actualCheck) {
  if (rowN < 0 || columnN < 0) { return 0; }
  if (rowN >= R || columnN >= C) { return 0; }
  return actualCheck(matrix, rowN, columnN);
}

lookAround(matrix, R, C, rowN, columnN, actualCheck) {
  return
      rangeCheck(matrix, R, C, rowN    , columnN - 1, actualCheck) +
      rangeCheck(matrix, R, C, rowN - 1, columnN    , actualCheck) +
      rangeCheck(matrix, R, C, rowN - 1, columnN - 1, actualCheck) +
      rangeCheck(matrix, R, C, rowN - 1, columnN + 1, actualCheck) +
      rangeCheck(matrix, R, C, rowN    , columnN + 1, actualCheck) +
      rangeCheck(matrix, R, C, rowN + 1, columnN    , actualCheck) +
      rangeCheck(matrix, R, C, rowN + 1, columnN + 1, actualCheck) +
      rangeCheck(matrix, R, C, rowN + 1, columnN - 1, actualCheck); 
}

getMinesCounts(matrix, R, C) {
  var counts = [];
  var posN = 0;
  for (var position in matrix) {
    counts.add(position != '*'?
        lookAround(
            matrix, R, C, posN ~/ C, posN % C,
            (matrix, rowN, columnN) => matrix[rowN * C + columnN] == '*' ? 1: 0):
        -1);
    posN++;
  }
  return counts;
}

checkIfEverybodyHasZeroAround(minesCount, R, C) {
  var posN = 0;
  for (var position in minesCount) {
    var nZeros = position > 0?
            lookAround(
                minesCount, R, C, posN ~/ C, posN % C, 
                (minesCount, rowN, cellN) => minesCount[rowN * C + cellN] == 0? 1: 0):
            -1;
    if (nZeros == 0) { return false; }
    posN++;
  }
  return true;
}

countZerosAround(minesCount, R, C) {
  var zerosAround = [];
  var posN = 0;
  for (var position in minesCount) {
    zerosAround.add(position > 0?
        lookAround(
            minesCount, R, C, posN ~/ C, posN % C, 
            (minesCount, rowN, cellN) => minesCount[rowN * C + cellN] == 0? 1: 0):
        -1);
    posN++;
  }
  return zerosAround;
}

checkIfAllZerosAreTogether(List minesCount, R, C) {
  var mapZerosToNeighborhoods = {};
  var posN = 0;
  var nNeighborhoods = 0;
  for (var position in minesCount) {
    if (position == 0) {
      var neighborhood = null;
      if (!mapZerosToNeighborhoods.containsKey(posN)) {
        neighborhood = [position];
        nNeighborhoods += 1;
        if (nNeighborhoods > 1) { 
          return false;
        }
        mapZerosToNeighborhoods[posN] = neighborhood;
      } else {
        neighborhood = mapZerosToNeighborhoods[posN];
      }
      lookAround(
          minesCount, R, C, posN ~/ C, posN % C, 
          (minesCount, rowN, cellN) {
            var neighbourZeroPos = rowN * C + cellN;
            if (minesCount[neighbourZeroPos] == 0) {
              mapZerosToNeighborhoods.putIfAbsent(
                  neighbourZeroPos, 
                  () => neighborhood);
            }
            return 0;
      });
    }
    posN++;
  }
  return true;
}

generateOnesPermutations(N, M) {
  var upbs = new List.filled(M, N);
  var ndxs = new List.generate(M, (ndx) => ndx);
  for (var i = M - 1; i >=0 ; i--) {
    upbs[i] = ndxs[i+1] - 1;
  }

  var curindex = 0; // lowest
  while(ndxs[curindex] < upbs[curindex]) {
    print("ndxs=$ndxs");
    ndxs[curindex]++;
    if (curindex > 0) {
      upbs[curindex-1] = ndxs[curindex];
      curindex--;
    }
  }
  
  // 000111   3,4,5 0,4,5
  // 001011
  // 001101
  // 001110
  // 010011
  // 010101
  // 010110
  // 011001
  
  if (curindex < M - 1) {
    curindex++;
  } else {
    return;
  }
  
  
}

inc(List m, bigCounter, R, C, M) {
  var top = 1 << R*C;
  while(bigCounter < top) {
    var b = ++bigCounter;
    var nbits = 0;
    while (b > 0) {
      var j = b ^ (b & (b-1));
      b = b & ~j;
      nbits++;
    }
    var newm = [];
    if (nbits == M) {
      for (var i = bigCounter; i > 0; i = i >> 1) {
        newm.add((i & 1) != 0?"*":".");
      }
      if (newm.length < R*C) {
        newm.addAll(new List.filled(R*C - newm.length, '.'));
      }
      m.clear();
      m.addAll(newm.reversed);
      return bigCounter;
    }
  }
  return null;
}

void main() {
  File f = new File('minesweeper.txt'); //C-small-attempt0.in'); // minesweeper.txt'); //
  var lines = f.readAsLinesSync();
  var T = int.parse(lines[0]);
  int lineNo = 1;
  for (var test = 0; test < T; test++) {
    var L = lines[lineNo++].split(' ');
    var R = int.parse(L[0]);
    var C = int.parse(L[1]);
    var M = int.parse(L[2]);
//    print("$R x $C with $M");

    var m = [];
    m.addAll(new List.filled(M, '*'));
    if (R*C - M == 1) {
      //
      // only one empty spot
      //
      m.add('c');      
    } else {
      m.addAll(new List.filled(R*C - M, '.'));
      
      m = new List.from(m.reversed);
      
      var BigCounter = M;
      while(BigCounter != null) {
        var mineCounts = getMinesCounts(m, R, C);
    
//        print('---mines---');
//        for (var nRow = 0; nRow < R; nRow++) {
//          print(mineCounts.getRange(nRow * C, (nRow + 1) * C)
//                      .map((v) => v == -1? "*": v)
//                      .join());
//        }
        
        bool doesEverybodyHaveZeroClose = 
            checkIfEverybodyHasZeroAround(mineCounts, R, C);
//        print('doesEverybodyHaveZeroClose = $doesEverybodyHaveZeroClose'); 

        if (doesEverybodyHaveZeroClose) {
          bool areAllZerosTogether =
            checkIfAllZerosAreTogether(mineCounts, R, C);
//          print('areAllZerosTogether = $areAllZerosTogether'); 
          if (areAllZerosTogether) {
            //
            // replace one(first) zero with 'c'
            //
            var i = 0; 
            while (i < mineCounts.length && mineCounts[i] != 0) { i++; }
            m[i] = 'c';
            break;
          }
        }
      
//        print('---zeros---');
//        var zeroCounts = countZerosAround(mineCounts, R, C);
//        for (var nRow = 0; nRow < R; nRow++) {
//          print(zeroCounts.getRange(nRow * C, (nRow + 1) * C)
//                      .map((v) => v == -1? "*": v)
//                      .join());
//        }
//        
        BigCounter = inc(m, BigCounter, R, C, M);
      }
      if (BigCounter == null) {
        m = null;
      }
    }
      
    print('Case #${test+1}: ');
    if (m != null) {
      for (var nRow = 0; nRow < R; nRow++) {
        print(m.getRange(nRow * C, (nRow + 1) * C)
                    .map((v) => v == -1? "*": v)
                    .join());
      }
    } else {
      print('Impossible');
    }
  }
}
