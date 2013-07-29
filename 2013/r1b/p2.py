import os
import math

from decimal import *

with open('problem2') as f:
  T = int(f.readline().strip())
  iT = 0

  while iT < T:
    [N, X, Y] = map(int, f.readline().strip().split(' '))
    #print "N=%d X=%d Y=%d" % (N, X, Y)


    i = (1.+math.sqrt(1.+8.*N))/4. - 1.
    if i == 0:
      result = 1.0 if X == 0 and Y == 0 else 0.0
    else:
      si = math.floor(i) * 2 # height of last fully completed triangle
      ei = si + 2 # height of outer triangle
      #print "i=%s need to look between si=%d and ei=%d" % (i, si, ei)

      if (Y <= si - abs(X)): 
        #print "for sure (X,Y)=(%d, %d) inside of inner triangle since Y=%d <= si=%d - abs(X)=%d" % (X, Y, Y, si, abs(X))
        result = 1.
      elif (Y > ei - abs(X)):
        #print "no chance since (X,Y)=(%d, %d) outside of outer triangle since Y=%d > ei=%d - abs(X)=%d" % (X, Y, Y, ei, abs(X))
        result = 0.
      else:
        #print "now (X,Y)=(%d, %d) should be on outer triangle side" % (X, Y)
        lastOne = (2 * (si / 2 + 1) * (si/2 + 1) - (si/2 + 1)) if si > 0 else 1
        nDiamonds = N - lastOne
        #print "lastOne=%d nDiamonds=%d" % (lastOne, nDiamonds)
        if nDiamonds == 0:
          result = 1.0 if X == 0 else 0.0
        else:
          overflow = max(nDiamonds - ei, 0)
          #print "overflow = %d" % (overflow)
          if Y < overflow:
            result = 1.
          else:
            capacity = ei - overflow
            Y = Y - overflow

            nDiamonds -= overflow*2
            upperRange = nDiamonds if nDiamonds <= ei else 2*ei - nDiamonds

            #print "capacity=%d, Y=%d, nDiamonds=%d, upperRange=%d" % (capacity, Y, nDiamonds, upperRange)

            if Y + 1 > upperRange:
              # target spot is above upper range what nDiamonds can get to
              result = 0.
            else:
              sums = 0
              for s in range(int(Y) + 1):
                # Count number of cases where number of diamonds on one side(bits set to 1)
                # is less than Y.
                # Number of cases where number of bits is s is calculcated as 
                # n choose k where n is capacity, k is s n choose k = n!/((n-k)!k!)
                sums += Decimal(math.factorial(upperRange))/Decimal(math.factorial(upperRange-s)*math.factorial(s))
                #print "s=%s sums=%s" % (s, sums)
              #print "sums=%s" % (sums)
              result = 1 - sums/Decimal(2**upperRange)

    print "Case #%d: %s" % (iT + 1, result)
    iT += 1
