void main() {
  final int N = 100;
  final int M = 82;
  List counters = new List.generate(M, (ndx) => M-ndx);
  List upbs = new List.filled(M, 0);
  upbs[0] = N;
  for (int i = 1; i < M; i++) {
    upbs[i] = counters[i-1] - 1;
  }
  
  while(true) {
//    print("counters= $counters");
    
    int i = M - 1;
    while (i >= 0 && counters[i] == upbs[i]) i--;
    
    if (i < 0) {
      break;
    }
    counters[i]++;
    for (int j = M - 1; j > i; j--) {
      counters[j] = M - j;
    }
    for (int j = i+1; j < M; j++) {
      upbs[j] = counters[j-1] - 1;
    }
  }
  
}