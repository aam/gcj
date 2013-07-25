import os
import math

with open('problem2') as f:
  T = int(f.readline().strip())
  iT = 0

  while iT < T:
    [N, X, Y] = map(int, f.readline().strip().split(' '))
    print "N=%d X=%d Y=%d" % (N, X, Y)


    i = (1.+math.sqrt(1.+8.*N))/4. - 1.
    if i == 0:
      result = 1.0 if X == 0 and Y == 0 else 0.0
    else:
      si = math.floor(i) * 2 # height of last fully completed triangle
      ei = si + 2 # height of outer triangle
      print "i=%s need to look between si=%d and ei=%d" % (i, si, ei)

      if (Y <= si - abs(X)): 
        print "for sure (X,Y)=(%d, %d) inside of inner triangle since Y=%d <= si=%d - abs(X)=%d" % (X, Y, Y, si, abs(X))
        result = 1.
      elif (Y > ei - abs(X)):
        print "no chance since (X,Y)=(%d, %d) outside of outer triangle since Y=%d > ei=%d - abs(X)=%d" % (X, Y, Y, ei, abs(X))
        result = 0.
      else:
        print "now (X,Y)=(%d, %d) should be on outer triangle side" % (X, Y)
        lastOne = (2 * si * si - si) if si > 0 else 1
        nDiamonds = N - lastOne
        print "lastOne=%d nDiamonds=%d" % (lastOne, nDiamonds)
        if nDiamonds == 0:
          result = 1.
        else:
          steps = nDiamonds
          slots = ei

          slot = Y + 1
          step = nDiamonds

          if step > slots and slot <= steps - slot:
            result = 1.
            print "result=%s since step=%d > slots=%d and slot=%d <= steps-slot=%d" % (result, step, slots, slot, steps-slot)
          else:
            print "step=%d, slot=%d out of %d" % ( step, slot, slots)
            denom = step + 1 if step <= slots else slots - (step - slots - 1)
            numerator = step - (slots  - slot) + 1 if step < slots else slots - slot + 1.
            result = numerator / denom
            print "result = %s/%s = %s" % ( numerator, denom, result)

        # if slots > steps


        # capacity = ei

        # overflow = max(math.ceil(nDiamonds/2) - capacity, 0)
        # print "lastOne=%d nDiamonds=%d si=%d capacity=%d overflow=%d" % (lastOne, nDiamonds, si, capacity, overflow)

        # if Y < overflow:
        #   result = 1.
        # elif Y > nDiamonds:
        #   result = 0.
        # else:
        #   capacityInPlay = capacity - overflow
        #   diamondsInPlay = nDiamonds - overflow * 2
        #   print "\tcapacityInPlay=%d diamondsInPlay=%d" % (capacityInPlay, diamondsInPlay)
        #   print "result = %d/%d" % (( diamondsInPlay - (Y - overflow) - 1.) ,  (diamondsInPlay - (Y - overflow)))
        #   result = (diamondsInPlay - (Y - overflow) - 1.) / (diamondsInPlay - (Y - overflow))

    print "Case #%d: %s" % (iT + 1, result)
    iT += 1
