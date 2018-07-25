Note 0
Copyright (C) 2018 Jonathan Hough. All rights reserved.
)

NB. knapsack solver, using genetic algorithm.
require 
coclass 'KnapsackObj'
coinsert 'GenObj'


NB. Create the knapsack solver object.
NB. Parameters: 
NB. 0: Optimize values
NB. 1: The weights
NB. 2: the sum, maximum value for sum of weights.
NB. 3: number of chromosomes.
NB.
NB. e.g. Given values (v0,v1,v2,..,vN), and the associated
NB. weights (w0, w1, w2,...,wN), optimize 
NB. vi + vj + ... + vk 
NB. under the constraint that
NB. wi + wj + ... + wk <: s for
create=: 3 : 0
'v w s n'=: y
gen=: (2&|@:?@:([ (, $ ]) #@:])) 
chromo=:<"1  n gen w
)

NB. get the list of chromosomes
chromosomes=: 3 : 0
chromo
)

NB. get the population size
populationSize=: 3 : 0
n
)

NB. get the chromosome length.
chromosomeLength=: 3 : 0
#w
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
sw=.(__&*)`(vs&[)@.(0&<:) [s- +/(I. >y){w[ vs=._1 * +/(I. >y){v

)

destroy=:codestroy