coclass 'TestKMeans'
coinsert 'TestBase'

create=: 3 : 0

a=: coname ''
objs=: ''
)


testKMeans1=: 3 : 0
D=: 2 2 $ 1 0 0 1
km=: (D;'Euclidean';2;'uniform') conew 'KMeans'
objs=: objs,km
(2 2 &-:) assertTrue ($ fit__km 100)
)

testKMeans2=: 3 : 0
D=: 10 5 $ 1 0.25 0.5 0 1 1 0 1 0.5 1 0 0.5 0.5 0.75 0 1 1 0.5 0.25
km=: (D;'Euclidean';4;'uniform') conew 'KMeans'
objs=: objs,km
(4 5 &-:) assertTrue ($ fit__km 100)
)

run=: 3 : 0 
testKMeans1 testWrapper 'Simple KMeans test 1' 
testKMeans2 testWrapper 'Simple KMeans test 2' 
)


destroy=: 3 : 0
for_i. i.# objs do.
  o=. i{objs
  try.
    destroy__o ''
  catch.
    smoutput 'Error destroying TestKmeans class.'
  end.
end.
codestroy ''
)

tg=: '' conew 'TestKMeans'
run__tg 0