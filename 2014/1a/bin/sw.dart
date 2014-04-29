void main() {
  var sampleinput = [
      '3',
      '3 2',
      '01 11 10',
      '11 00 10',
      '2 3',
      '101 111',
      '010 001',
      '2 2',
      '01 10',
      '10 01'
      ];
  var it = sampleinput.iterator;
  it.moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var t = 0; t < T; t++) {
    var line = it.current.split(" "); it.moveNext();
    var N = int.parse(line[0]);
    var L = int.parse(line[1]);
    var outlets = it.current.split(" ").map((x) => int.parse(x, radix: 2));
    it.moveNext();
    var devices = it.current.split(" ").map((x) => int.parse(x, radix: 2));
    it.moveNext();
    print("\tCase #${t+1}: N=$N L=$L outlets=$outlets devices=$devices");
    var ibit = 0;
    while (ibit < L) {
      divide(outlets, ibit);
      ibit++;
    }
    print("Case #${t+1}:");    
  }
}

divide(outlets, ibit) {
  var needOn = [];
  var needOff = [];
  var bitvalue = 1 << ibit;
  for (var outlet in outlets) {
    if (outlet & bitvalue != 0) {
      needOn.add(outlet);
    } else {
      needOff.add(outlet);
    }
  }
}