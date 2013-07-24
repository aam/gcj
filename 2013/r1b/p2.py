import os
import math

with open('problem2') as f:
  T = int(f.readline().strip())
  iT = 0

  while iT < T:
    [N, X, Y] = map(int, f.readline().strip().split(' '))
    print "N=%d X=%d Y=%d" % (N, X, Y)


    i = (1.+math.sqrt(1.+8.*N))/4. - 1.
    si = math.floor(i) * 2
    ei = si + 2
    print "need to look between floor(%s)=%d and ceil(%s)=%d" % (i, si, i, ei)


    if (X < -ei or X > ei or
       Y > ei - X and X >= 0 or 
       Y > X + ei and X < 0):
      print "no chance X=%d Y=%d ei=%d" % (X, Y, ei)
      result = 0.
    else:
      if (X < 0 and Y < ei - X or
         X >= 0 and Y < X + ei):
        print "for sure"
        result = 1.
      else:
        lastOne = 2 * ei * ei - ei
        nDiamonds = N - lastOne
        if nDiamonds == 0:
          result = 1.
        else:
          capacity = ei + 1
          overflow = max(math.ceil(nDiamonds/2) - capacity, 0)
          print "lastOne=%d nDiamonds=%d ei=%d capacity=%d overflow=%d" % (lastOne, nDiamonds, ei, capacity, overflow)

          if Y < overflow:
            result = 1.
          elif Y > nDiamonds:
            result = 0.
          else:
            capacityInPlay = capacity - overflow
            diamondsInPlay = nDiamonds - overflow * 2
            print "\tcapacityInPlay=%d diamondsInPlay=%d" % (capacityInPlay, diamondsInPlay)
            result = (diamondsInPlay - (Y - overflow) - 1) / (diamondsInPlay - (Y - overflow))

    print "Case #%d: %d" % (iT + 1, result)
    iT += 1
