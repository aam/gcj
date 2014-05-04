import "dart:io";

main() {
  var s = [
'1',
'2',
'addc',
'adc',
'2',
'tjimobodhcfxjlkmwkjeeik',
'skqmaneiixfnsdudxsfpocfmxmlefgqxsglsurcephthnnkkhrcyvhkvtvzadpzwykquctytcrapgmcnfenclxxguzgyofworo',
'2',
'fffpppxxrrrrjllfwyzhhuhhhhhhhnccccauuaaaaaahhtzgeophoomjjj',
'fppxxrjlllfffwyyzhhuuuuuuuuuhhnccccccauuaahttttzzzgeophhhomjjj',
'2',
'mmaw',
'maw',
'2',
'gcj',
'cj',
'2',
'abc',
'abc',
];
//  var it = s.iterator; it.moveNext();
      
  File f = new File('A-large-practice.in');
  var it = f.readAsLinesSync().iterator..moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var t = 0; t < T; t++) {
    var N = int.parse(it.current); it.moveNext();
    var ss = <String>[];
    for (var n = 0; n < N; n++) {
      ss.add(it.current); it.moveNext();
    }
    
    var prevch = ' ';
    var sbCompressed = new StringBuffer();
    for (var ch in ss[0].split('')) {
      if (ch != prevch) {
        sbCompressed.write(ch);
      }
      prevch = ch;
    }
    var compressed = sbCompressed.toString();
//    print("\tcompressed: $compressed");
    
    var diffs = new List.generate(compressed.length, 
        (_) => new List.filled(N, 0));
    var segments = {}; // map index in compressed to number of reps
    var indexes = new List.filled(N, 0); // current index in every string
    for (var i = 0; i < compressed.length; i++) {
//      print("\t+$compressed");
//      print("\t ${' '*i}*");
      for (var j = 0; j < N; j++) {
        var sj = ss[j];
//        print("\t-$sj");
//        print("\t ${' '*indexes[j]}^");
        if (indexes[j] == sj.length) {
          diffs = null; // reached end of shorter string, haven't finished compressed
          break;
        }
        var diff = 0; // difference between sj and compressed
        if (sj[indexes[j]] == compressed[i]) {
          indexes[j]++;
        } else {
          if (indexes[j] == 0) {
            diffs = null; // difference at first character - no chance
            break;
          }
          if (sj[indexes[j]-1] == sj[indexes[j]]) {
            do {
              indexes[j]++;
              diff++;
//              print("\t*$sj");
//              print("\t ${' '*indexes[j]}^");
            } while(indexes[j] < ss[j].length 
               && sj[indexes[j]-1] == sj[indexes[j]]);
            if (sj[indexes[j]] == compressed[i]) {
              indexes[j]++;
            } else {
              diffs = null; // can't reconcile even after skipping dups
            }
          } else {
            diffs = null; // difference can't be because of duplicated char
            break;
          }
        }
        if (diffs != null && diff > 0) {
          diffs[i-1][j] = diff;
        }
//        print("\t-$sj");
//        print("\t$j${' '*indexes[j]}^");
      }
      if (diffs == null) {
        break;
      }
    }
    if (diffs != null) {
      for (var j = 0; j < N; j++) {
        var sj = ss[j];
        var last = compressed[compressed.length-1];
        var diff = diffs[compressed.length-1][j];
        while (indexes[j] < sj.length) {
          if (sj[indexes[j]] == last) {
            diff++;
            indexes[j]++;
          } else {
            diffs = null; // next characters don't match 
            break;
          }
        }
        if (diffs == null) {
          break;
        }
        diffs[compressed.length-1][j] = diff;
      }
    }
    
//    print("\tdiffs=$diffs");
    
    var totaldiff = null;
    if (diffs != null) {
      totaldiff = 0;
      for (var d in diffs) {
        var s = new Set();
        s.addAll(d);
        if (s.length > 1) {
          var mindiff = null;
          for (var i = 0; i < N; i++) {
            var diff = 0;
            for (var j = 0; j < N; j++) {
              if (i != j) {
                diff += (d[j] - d[i]).abs();
              }
            }
            if (mindiff == null || diff < mindiff) {
              mindiff = diff;
            }
          }
          totaldiff += mindiff;
        }
      }
    }
    
    print("Case #${t+1}: ${totaldiff == null? "Fegla Won": totaldiff}");
  }
}