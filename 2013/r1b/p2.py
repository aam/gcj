import os
import math

with open('problem2') as f:
  T = int(f.readline().strip())
  iT = 0

  while iT < T:
    [N, X, Y] = map(int, f.readline().strip().split(' '))
    print "N=%d X=%d Y=%d" % (N, X, Y)


    i = (1.+math.sqrt(1.+8.*N))/4. - 1.
    si = math.floor(i) * 2 # height of last fully completed triangle
    ei = si + 2 # height of outer triangle
    print "need to look between si=%d and ei=%d" % (si, ei)

    if (Y <= si - abs(X)): 
      print "for sure (X,Y)=(%d, %d) inside of inner triangle since Y=%d <= si=%d - abs(X)=%d" % (X, Y, Y, si, abs(X))
      result = 1.
    elif (Y > ei - abs(X)):
      print "no chance since (X,Y)=(%d, %d) outside of outer triangle since Y=%d > ei=%d - abs(X)=%d" % (X, Y, Y, ei, abs(X))
      result = 0.
    else:
      print "now (X,Y)=(%d, %d) should be on outer triangle side" % (X, Y)
      lastOne = 2 * si * si - si
      nDiamonds = N - lastOne
      if nDiamonds == 0:
        result = 1.
      else:
        capacity = si + 1
        overflow = max(math.ceil(nDiamonds/2) - capacity, 0)
        print "lastOne=%d nDiamonds=%d si=%d capacity=%d overflow=%d" % (lastOne, nDiamonds, si, capacity, overflow)

        if Y < overflow:
          result = 1.
        elif Y > nDiamonds:
          result = 0.
        else:
          capacityInPlay = capacity - overflow
          diamondsInPlay = nDiamonds - overflow * 2
          print "\tcapacityInPlay=%d diamondsInPlay=%d" % (capacityInPlay, diamondsInPlay)
          result = (diamondsInPlay - (Y - overflow) - 1.) / (diamondsInPlay - (Y - overflow))

    print "Case #%d: %d" % (iT + 1, result)
    iT += 1
