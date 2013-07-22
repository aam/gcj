import os
import math

with open('problem2') as f:
  T = int(f.readline().strip())
  iT = 0

  while iT < T:
    [N, X, Y] = map(int, f.readline().strip().split(' '))
    print "N=%d X=%d Y=%d" % (N, X, Y)


    i = (1.+math.sqrt(1.+8.*N))/4.
    si = math.floor(i)
    ei = si + 1
    print "need to look between floor(%s)=%d and ceil(%s)=%d" % (i, math.floor(i), i, math.floor(i) + 1)


    if (X < -si or X > si or
       Y > si - X and X > 0 or 
       Y > X + si and X < 0):
      result = 0.
    else:
      if (X < 0 and Y < si - X or
         X > 0 and Y < X + si):
        result = 1.
      else:
        result = 1.
        r = N - si
        cx = -si
        cy = 0
        while r > 0 and (cx != X and cy != Y):
          
          result = result / 2.

    print "Case #%d: %d" % (iT + 1, result)
    iT += 1
