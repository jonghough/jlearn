Note 0
Copyright (C) 2022 Jonathan Hough. All rights reserved.
)



NB. DBSCAN clustering algorithm.
coclass 'DBSCAN'


NB. Creates an instance of the DBSCAN class. Used for
NB. Clustering data, with an unkown number of labels.
NB. y:
NB. 0: dataset
NB. 1: distance metric to use. Can be
NB.    'Euclidean' for Euclidean metric
NB.    'Manhatten' for Manahatten metric
NB. 2: epsilon value. The minimum distance between two points.
NB. 3. low value. The minimum number of neighboring
NB.    points (with epsilon distance).
NB.
NB. Example:
NB.	X=: ? 100 2 $ 0
NB.	db=: (X;'Euclidean';0.3;5) conew 'DBSCAN'

create=: 3 : 0
'X metric epsilon low'=: y
L=: __#~#X NB. __ uncertain
'Metric must be either "Manhatten" or "Euclidean"' assert (<metric) e. ('Manhattan';'Euclidean')
if. metric -: 'euclidean' do.
  dist=: distEucidean
else.
  dist=: distManhattan
end.
)

distEuclidean=: (+/)&.:*:@:-
distManhattan=: +/@:|@:-



NB. Run the DBSCAN algorthm.
NB. y: any. Parameter will not be used.
NB. returns: the labels for each data point.
fit=: 3 : 0
c=. 0
L=: __#~#X

while. 1 do.
  l=: I. L= __
  if. 0 = # l do.
    break.
  end.
  p=. 0{l
  fitOne (p{X);'';p
end.
L
)

fitOne=: 3 : 0
'p c i'=. y NB. current point, current cluster, cluster id
n=. X rq p
cp=. n-.c
L=: i (cp)}L
NB. is boundary or noise
if. 0=#c do. NB. noise
  L=: i (i)}L
elseif. low < # cp do.
  for_k. cp do.
    r=. k {X
    c=. I.L=i
    fitOne r;c;i
  end.
end.
0
)

rq=: 4 : 0
I. epsilon > x dist"1 _ y
)