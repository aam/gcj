import os
import math

def stepsToCoverTheGap(a, b, n, maxn):
  delta = b-a
#  print "stepsToCoverTheGap: a=%d b=%d delta=%d n=%d, maxn=%d" % (a,b,delta,n, maxn)
  if (delta < 0 or n >= maxn):
    return (n, a)
  delta -= a
  print "*** adding %d to new a=%d" % (a-1, a+a-1)
  a += a-1
  return stepsToCoverTheGap(a, b, n+1, maxn)


with open('problem1', 'r') as f:
  ntestcases = int(f.readline())
  for itestcase in range(ntestcases):
    [a, n] = map(int, f.readline().strip().split(' '))
    m = sorted(map(int, f.readline().strip().split(' ')))

    print("Solving a=%d n=%d m=%s" % (a, n, m))

    i = 0
    nremaining = len(m)
    totalgap = 0
    while i < len(m) and totalgap < len(m):
      #print "totalgap=%d nremaining=%d" % (totalgap, nremaining)
      gap = m[i] - a
      if gap < 0:
        print "with our weight of %d absorbing %d" % (a, m[i])
        a += m[i]
      else:
        (nsteps, a) = stepsToCoverTheGap(a, m[i], 0, nremaining)
        if nsteps >= nremaining:
          print "*** too many steps %d - dropping the rest %d " % (nsteps, nremaining)
          totalgap += nremaining
          break
        else:
          a += m[i]
          print "*** took %d steps to grew to new a=%d to absorb %d" % (nsteps, a, m[i])
        totalgap += nsteps
      nremaining -= 1
      i+=1

    print("Case #%d: %d" % (itestcase + 1, min(totalgap, len(m))))