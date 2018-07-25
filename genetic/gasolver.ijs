Note 0
Copyright (C) 2018 Jonathan Hough. All rights reserved.
)


NB. Genetic Algorithm Solver implementation. This implementation
NB. requires two object. The 'GenObj' which creates and holds
NB. chromosome population and cost information, and the 'GASolver'
NB. object which runs the search algorithm whose goal is to find
NB. the chromosome which minimizes the cost function.

NB. Abstract base 'GenObj' class. Extend this class for use with
NB. the 'GASolver'.
coclass 'GenObj'

create=: destroy=: codestroy

NB. get the list of chromosomes
chromsomes=: 3 : 0
0
)

NB. get the population size
populationSize=: 3 : 0
0
)

NB. get the chromosome length.
chromosomeLength=: 3 : 0
0
)

NB. Gets a new sequence of chromosomes,
NB. for instance if the GP algorithm is
NB. not improving, restart.
newSequence=: 3 : 0
''
)

NB. runs the cost function on each chromosome. Returns the
NB. cost for each chromosome.
cost=: 3 : 0"0
0
)

NB. Example GenOj class. This is an example implementation of
NB. GenObj.
NB. Travelling Salesman Problem Class. This class defines the
NB. travelling Salesman problem for a given city count, and
NB. chromosome population count.

coclass 'TSPObj'
coinsert 'GenObj'
NB. Creates a 'TSPObj'. Will create random distances between all
NB. cities.
NB. Parameters:
NB. 0: Population of Chromsomes size. Larger sizes take longer to
NB.    run searches on, but can give better results.
NB. 1: City count. The number of cities.
create=: 3 : 0
'popSize cCount'=: y
list=: (#~ </"1)@(#: i.@:(*/)) 2 # cCount
cities=: list,"(1 1) (1,~ 2!cCount) $ 1000 * (? (2!cCount) # 0)
cities=: modifyDistance"1 cities
boxedcities=: <"1 ( 0 1 {"1 cities)
chromo=: (] ?&.> (<"0@:(popSize&$)))cCount
)


newSequence=: 3 : 0
''
)

chromosomes=: 3 : 0
chromo
)


populationSize=: 3 : 0
popSize
)

chromosomeLength=: 3 : 0
cCount
)

cost=: 3 : 0"0
edges=. <"1 /:~"1 (2]\ > y)
+/, 2{"1 ((edges ="0 _ boxedcities) # cities)

)

modifyDistance=: 3 : 0
'from to distance'=. y

if. to = >: from do.
  distance=. 1
elseif. distance < 10 do.
  distance=. 10
end.
from, to, distance
)

destroy=: codestroy







coclass 'GASolver'

convertString=: #.@:".@:((,&' '@[,])/)
addBString=: ,@:(*@:+&."."0) NB. add binary strings.

NB. Creates an instance of the GASolver class.
NB. The solver needs a GenObj object, which holds the
NB. chromosome list and cost function. Also the
NB. mutation rate, mutation population, selection population
NB. needs to be set. The selected population must be less than
NB. or equal to the mutation population, and the mutation rate
NB. must be a value between 0 and 1.
NB. Parametets:
NB. 0: GenObj instance.
NB. 1: Mutation rate, in range (0,1)
NB. 2: Mutation population, must be less than or equal to
NB.    the GenObj population size. If both are the same, then
NB.    all chromosomes, after ordering, can undergo mutation.
NB. 3: Selected population. Must be at most the same size as
NB.    Mutation population.
NB. 4: threshold of the minimum cost function. If minimum cost
NB.    is less than this value, then the algorithm will stop.
NB. 5: Unique flag, if true all items per chromosome should be unique.
NB.    i.e. no repeats in a chromosome.
NB. 6: Log realtime flag. If true, best result will be displayed on
NB.    each iteration end.
NB. Example:
NB. > myGASolver =: (myGenObj;0.4;100;50;0.4;1) conew 'GASolver'
create=: 3 : 0
'genobj mRate mPop sPop threshold unique log'=: y
pop=: populationSize__genobj
chromosomes=: chromosomes__genobj ''

)




NB. Mate the chromosomes. Mother, Father and 2 children
NB. will produce mutated child chromosomes which will
NB. replace the children in the chromosome list.
mate=: 3 : 0
'mother father child1 child2'=: y
cutoff=. 5

for_j. i. # mother do.
  if. j < cutoff do.
    for_k. i. chromosomeLength__genobj '' do.
      if. unique *. -.(k e. child1) do.
        child1=. k (j}) child1
        break.
      end.
    end.
    for_k. i.chromosomeLength__genobj '' do.
      if. unique *. -.(k e. child2) do.
        child2=. (k{father) j} child2
        break.
      end.
    end.
  elseif. j > cutoff do.
    for_k. i. chromosomeLength__genobj '' do.
      k=. <: (chromosomeLength__genobj '') - k
      if. unique *. -.(k e. child1) do.
        child1=. (k) j}child1
        break.
      end.
    end.
    for_k. i.chromosomeLength__genobj '' do.
      k=. <: (chromosomeLength__genobj '') - k
      if. unique *. -.((k{father) e. child2) do.
        child2=. (k{father) j}child2
        break.
      end.
    end.    
  end.
end.


NB. handle mutations

'c1 c2'=. ? 2 # 0
if. mRate > c1 do.
  mutated=. ? 2 # chromosomeLength__genobj ''
  m1=. (0{mutated){child1
  m2=. (1{mutated){child1
  child1=. (m2, m1) mutated} child1
end.

if. mRate > c2 do.
  mutated=. ? 2 # chromosomeLength__genobj ''
  m1=. (0{mutated){child2
  m2=. (1{mutated){child2
  child2=. (m2, m1) mutated} child2
end.

child1;child2
)


NB. Sort (ascending) the chromsomes of the GenOBj. The order
NB. is decided by the cost function.
sortChromosomes=: 3 : 0
(] /: cost__genobj"0) y
)


fit=: 4 : 0
generations=. x
orderedChromosomes=. y
oc=. orderedChromosomes
minCost=: _
minCostNoChange=: 0
c=. 0
while. c < generations do.
  c=. c + 1
  nextchild=. mPop
  for_j. i. sPop do.
    mother=. j { oc
    father=. (? sPop) { oc
    child1=. nextchild { oc
    child2=. (>: nextchild) { oc
    
    newGeneration=. mate mother,father,child1,child2
    oc=. newGeneration (nextchild, (>: nextchild)) } oc
    nextchild=. nextchild + 2
  end.
  oc=. sortChromosomes oc
  chromo=: oc
  cmincost=. cost__genobj {. oc
  if. cmincost < minCost do.
    minCost=: cmincost
    minCostNoChange=: 0
  else. minCostNoChange=: >: minCostNoChange end.
  if. 0= 10 | c do.
    NB. If minCost is infinity after 10 iterations,
    NB. get new sequence of chromosomes.
    if. minCost=_ do.
      oc=. newSequence__genobj ''
    end.
    chromo__genobj=: chromo
  end.
  if. log do.
    smoutput 'Iteration complete: ',":cost__genobj {. oc
    wd^:1 'msgs'
  end.
  if. threshold > cost__genobj {. oc do.
    break.
  end.
end.
oc
)


destroy=: 3 : 0
try.
  if. -. genobj -: '' do.
    destroy__genobj ''
  end.
catch.
  smoutput 'Error destroying GASolver'
end.
codestroy ''
)
