import 'dart:io';

void main() {
  var f = new File('A-large-practice.in');
  var it = f.readAsLinesSync().iterator; 
  it.moveNext();
  var T = int.parse(it.current); it.moveNext();
  for (var t = 0; t < T; t++) {
    var line = it.current.split(" "); it.moveNext();
    var N = int.parse(line[0]);
    var L = int.parse(line[1]);
    List outlets = it.current.split(" ").map((x) => int.parse(x, radix: 2)).toList();
    it.moveNext();
    var devices = it.current.split(" ").map((x) => int.parse(x, radix: 2)).toList();
    it.moveNext();
    
    var ibit = 0;
    var permutationsSet = [];
    var fixedSet = {};
    var impossible = false;
    String solution = null;
    while (ibit < L) {
      var ibitvalue = 1 << ibit;
      var outlet_i_bit1s =
          outlets.fold(
              0,
              (V, outlet) => V + (outlet & ibitvalue == ibitvalue? 1: 0));
      var device_i_bit1s =
          devices.fold(
              0,
              (V, devices) => V + (devices & ibitvalue == ibitvalue? 1: 0));
      
      if (outlet_i_bit1s == device_i_bit1s) {
        if (outlet_i_bit1s == N - device_i_bit1s) {
          permutationsSet.add(ibit);
        } else {
          fixedSet[ibit] = 0; // no need to change i-bit
        }
      } else if (outlet_i_bit1s == N - device_i_bit1s) {
        if (outlet_i_bit1s == device_i_bit1s) {
          permutationsSet.add(ibit);
        } else {
          fixedSet[ibit] = 1; // have to flip i-bit
        }
      } else {
        impossible = true;
        break;
      }
      
      ibit++;
    }
    var minSwitches = null;
    if (!impossible) {
      var flipVector = 0;
      var sb = new StringBuffer(); 
      for (var i = L - 1; i >= 0; i--) {
        if (fixedSet.containsKey(i)) {
          sb.write(fixedSet[i]);
          flipVector = (flipVector << 1) | fixedSet[i]; 
        } else {
          flipVector <<= 1; 
          if (permutationsSet.contains(i)) {
            sb.write(".");
          } else {
            sb.write("?");
          }
        }
      }
      solution = sb.toString();
      
      if (permutationsSet.length == 0) {
        minSwitches = solution.split('').fold(0, (E, V) => (V == '0'? 0: 1) + E);
      } else {
        for (var di = 0; di < devices.length; di++) {
          for (var oi = 0; oi < outlets.length; oi++) {
            var switches = devices[di] ^ outlets[oi];
            if (switches & flipVector == flipVector) {
              // verify that rest of devices can be matched with this 
              // setting of switches
              var remainingdevices = new List.from(devices);
              remainingdevices.remove(devices[di]);
              var remainingoutlets = new Set();
              remainingoutlets.addAll(outlets);
              remainingoutlets.remove(outlets[oi]);
              while (remainingdevices.isNotEmpty) {
                var remainingdevice = remainingdevices.removeAt(0);
                var matchingoutlet = remainingdevice ^ switches;
                if (!remainingoutlets.remove(matchingoutlet)) {
                  break;
                }
              }
              
              if (remainingdevices.isEmpty) {
                // all devices plugged in
                var nSwitches = 0;
                var c = switches;
                while (c > 0) {
                  c = c & ~(c ^ (c - 1));
                  nSwitches++;
                }
                if (minSwitches == null || nSwitches < minSwitches) {
                  minSwitches = nSwitches;
                }
              }
            }
            
          }
        }
      }
      
    }
    print("Case #${t+1}: ${impossible?'NOT POSSIBLE':minSwitches}");    
  }
}
