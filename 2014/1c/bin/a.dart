import "dart:io";

main() {
  var s = [
    '1',
    '30/40',
    '3/6',
    '1/4',
    '2/23',
    '123/31488'
];
  var it = s.iterator; it.moveNext();
      
//  File f = new File('A-large (1).in');
//  var it = f.readAsLinesSync().iterator..moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var t = 0; t < T; t++) {
    
    var l = it.current.split("/"); it.moveNext();
    var p = int.parse(l[0]);
    var q = int.parse(l[1]);

    var first11 = null;
    var gen = 0;
    while (p > 0) {
//      print("$p/$q");
      if (p == q) {
        // got 1/1
        if (first11 == null) {
          first11 = gen;
        }
        break;
      }
      if (p > q) {
        if (first11 == null) {
          first11 = gen;
        }
        while (p > q) {
          p = p - q;
        }
      }
      if (q.isEven) {
        q = q >> 1;
      } else {
        first11 = null;
        break;
      }
      gen++;
    }
    
    print("Case #${t+1}: ${first11 != null? first11: 'impossible'}");
  }
}