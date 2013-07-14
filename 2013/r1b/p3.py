import copy
from sets import Set

def findMinPenalty(trie, starti, s, startiLastError):
  #print "findMinPenalty trie=%s" % (trie)
  canBeErroneous = []
  minPenalty = 32767
  minLastError = -1
  minPattern = ""
  queue = [(starti, 0, startiLastError, 0, "")]
  while len(queue) > 0:
    (i, j, iLastError, penalty, pattern) = queue.pop()
    #print "=>\n\t%d: Popped (i=%d, j=%d, iLastError=%d, penalty=%d)" % (len(queue), i, j, iLastError, penalty)

    if i >= len(s) or j == -1: # reached end of the string or end of the trie
      #print "reached end of the string or end of the trie"
      if j == -1:
        if penalty < minPenalty or penalty == minPenalty and iLastError < minLastError:
          minPenalty = penalty
          minLastError = iLastError
          minPattern = pattern
          #print "\tminPenalty = %d" % penalty
        for v in queue:
          (vi, vj, viLastError, vpenalty, vpattern) = v
          if vpenalty > minPenalty:
            #print "\tRemoving (%s, %s, %s, %s, %s)" % (vi, vj, viLastError, vpenalty, vpattern)
            queue.remove(v)
      continue

    if iLastError + 4 < i:
      for nextj in Set(trie[j].values()):
        # adding "what-if" error recovery options
        #print "\t\tAdding (i=%d, j=%d, iLastError=%d, penalty=%d) recovery option" % (i + 1, nextj, i, penalty + 1)
        queue.append((i + 1, nextj, i, penalty + 1, pattern + "."))

    #print "\t\ts[i]=%s len(trie)=%s i=%d len(s)=%d" % (s[i], len(trie), i, len(s))
    #print "\t\ttrie[j]=%s" % (trie[j])

    if (s[i] in trie[j]) and (trie[j][s[i]] == -1):
      if penalty < minPenalty or penalty == minPenalty and iLastError < minLastError:
        minPenalty = penalty
        minLastError = iLastError
        minPattern = pattern + s[i]
        #print "\t\treached end of trie with minPenalty = %d, pattern=%s" % (penalty, pattern)
      for v in queue:
        (vi, vj, viLastError, vpenalty, vpattern) = v
        if vpenalty > minPenalty:
          #print "\tRemoving (%s, %s, %s, %s, %s)" % (vi, vj, viLastError, vpenalty, vpattern)
          queue.remove(v)
    elif (s[i] in trie[j]) and (i < len(s) - 1):
      #print "\t\tMatch - adding (%d, %d, %d, %d, %s) " % (i + 1, trie[j][s[i]], iLastError, penalty, pattern + s[i])
      queue.append((i + 1, trie[j][s[i]], iLastError, penalty, pattern + s[i]))
    #else:
      #print "\t\tNo match"
  
  return (minPenalty, minLastError, minPattern)

hashToWord = {}
shortwords = []
allws = []
boundary = {}

with open('garbled_sorted_dict.txt', 'r') as f:
#with open('dict.txt', 'r') as f:
  lenw = 1
  for w in f:
    w = w.strip()
    # if len(w) > lenw:
    #   boundary[lenw] = len(allws)
    #   lenw += 1
    # allws.append(w)
    # if len(w) > 4:
    #   for i in range(len(w) - 3):
    #     substr = w[i:i+4]
    #     if substr in hashToWord:
    #       hashToWord[substr].append(len(allws) - 1)
    #     else:
    #       hashToWord[substr] = [len(allws) - 1]
    # else:
    shortwords.append(w)
#  print "shortwords = %s" % shortwords

with open("problem3") as f:
  nproblems = int(f.readline().strip())
  iproblem = 0

  candidates = shortwords

  # idxslongcandidates = Set([])
  # for i in range(len(s) - 3):
  #   substr = s[i:i+4]
  #   if substr in hashToWord:
  #     #print 'at %d can have %s based on %s' % (i, hashToWord[substr], substr)
  #     for idxw in hashToWord[substr]:
  #       idxslongcandidates.add(idxw)
  #   #else:
  #     #print 'at %d no options - something is messed up around that position' % i
  # for idxw in sorted(idxslongcandidates):
  #   candidates.append(allws[idxw])

#    print "%d candidates" % (len(candidates))

  tries = [] # array of tries where index is length of the word represented by this trie

  iword = 0
  clength = 0
  for w in candidates:
    state = 0
    i = 0
    if clength < len(w):
      while clength < len(w):
        trie = [{}]
        tries.append(trie)
        clength += 1
      nstates = 1
#        print "clength=%d" % clength

    for c in w:
      if i == len(w) - 1:
        trie[state][ c] = -1
      else:
        if c in trie[state]:
          state = trie[state][ c]
        else:
          trie[state][ c] = nstates
          ##print "new: %s -(%s)-> %s" % (state, c, nstates)
          trie.append({})
          state = nstates
          nstates += 1
      i += 1
    #print "after %s trie is %s" % (w, trie)
    iword += 1
    if iword % 100000 == 0:
      print iword

  while iproblem < nproblems:

    s = f.readline().strip()
    #print(s)

    visited = {}
    queue = [(0, [-5], "")]
    minimumPenalty = 65535
    while len(queue) > 0:
      print "----"
      #print queue
      (i, errors, newpattern) = queue.pop()
      #print "%d:queue.pop -> (%d, %s)" % (len(queue), i, errors)
      thisplace = (i, errors[len(errors)-1])

      if (str(thisplace)) in visited:
        lenerrors = visited[str(thisplace)]
        if lenerrors <= len(errors):
          #print "...skip"
          continue
      visited[str(thisplace)] = len(errors)

      if i == len(s): # got to the end of the string
        #print "got to the end of the string with %d errors, minimumPenalty=%d" % (len(errors), minimumPenalty)
        if len(errors) - 1 < minimumPenalty:
          minimumPenalty = len(errors) - 1
          #print "got to the end with minimumPenalty=%d queue size=%d" % (minimumPenalty, len(queue))
          if minimumPenalty == 0: # best possible case - no errors
            break
          for v in queue:
            (vi, verrors, vpattern) = v
            if len(verrors) - 1 >= minimumPenalty:
              queue.remove(v)
      else:
        #print "Going through %s tries " % (range(min(len(tries), len(s) - i)))
        for itrie in range(min(len(tries), len(s) - i)-1, -1, -1):
          # print "=>%d:findMinPenalty(tries[itrie]=%s, i=%d, s=%s, errors[len(errors)-1]=%s)" % (
          #   itrie,
          #   tries[itrie],
          #   i,
          #   s[:i] + ">" + s[i:i+itrie+1] + "<" + s[i+itrie+1:],
          #   errors[len(errors)-1])
          (penalty, newlasterror, pattern) = findMinPenalty(tries[itrie], i, s, errors[len(errors)-1])
          # print "<=%d:findMinPenalty returned (penalty=%d, newlasterror=%d, pattern=%s), i+itrie = %d, len(s)=%d" % (
          #   itrie,
          #   penalty,
          #   newlasterror,
          #   pattern,
          #   i+itrie,
          #   len(s))

          if penalty < 32767:
            if newlasterror >= 0:
              newerrors = copy.deepcopy(errors)
              newerrors.extend([newlasterror] * penalty)
            else:
              newerrors = errors
            print "%s, %s" % (
               s[:i] + ">" + s[i:i+itrie+1] + "<" + s[i+itrie+1:],
               ((newpattern + ",") if newpattern != "" else "") + ">" + pattern + "<"
               )
            if i + itrie < len(s) and len(newerrors) - 1 < minimumPenalty:
              #print "appending (%d, %s)" % (i + itrie + 1, newerrors)
              queue.append((i + itrie + 1,
                            newerrors,
                            ((newpattern + ",") if newpattern != "" else "") + pattern))

    print "Case #%d: %d" % (iproblem + 1, minimumPenalty)
    iproblem += 1
