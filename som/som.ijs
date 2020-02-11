Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


require jpath '~Projects/jlearn/clustering/kmeans.ijs'
load 'viewmat'


NB. Self Organizing Map.
coclass 'SOM'

axbgrid=: i.@:[ <@,"0"0 _ i.@:]  NB. a x b grid of coordinates

sqNeighbourhood=: 3 : 0 "_
> dims $ , (,cmap) (((+/&.:*:)@:-)&.>)"_ 0 y
)

expNeighbourhood=: 3 : 0"_
ssq=. > dims $ ,(,cmap) (((+/&.:*:)@:-)&.>)"_ 0 y
^--:%:(ssq % radius)
)

NB. Creates an instance of the Self-Organizing Map class.
NB. Arguments:
NB. 0: data - the data to use when training the class
NB. 1: dims - the width (and height) of the map. e.g if
NB.    dims = 10, then the map will be a 10x10 grid of vectors.
NB. 2: vlen - vector length. length of each vector. Given
NB.    vlen and dims the map's shape will be dims x dims x vlen.
NB. 3: leanrRate - the initial learning rate used for training.
NB. 4: lrConst - learning rate constant, used for training. Large
NB.    values lead to slower  learningRate decay.
create=: 3 : 0
'data dims vlen learnRate lrConst '=: y
assert. 2=$dims
assert. 1=#,vlen
'The number of features of the input data must be equal to vlen.' assert ({:$data) = vlen
cmap=: { <@i."0 dims 
vertmap=: ?(dims, vlen) $ 0
)

fit=: 3 : 0
epochs=: y
c=. 0
while. epochs > c=.c+1 do. 
  dp=: (?@:# { ])data                                            NB. current point
  radius=: (%:+:*:vlen)*^-c % (epochs % ^. (%:+:*:vlen))         NB. radius boundary
  learnRate=: lrConst * ^ - c % epochs                           NB. current epoch's learning rate
  dist=: cmap ((%:@:(+/)@:*:)@:((,dp)&-@{))"0 _ vertmap          NB. distances
  min=: (,cmap){~ I. (=<./), dist                                NB. coords of min v.
  radii=: sqNeighbourhood min                                    NB. distance to min from each point
  vs=: >(<"1 ,/vertmap){~I., radius > radii                      NB. vertices which will be updated
  ps=: (,cmap){~I., radius > radii                               NB. indices of vertices to update
  vertmap=: (vs + learnRate * dp-"1 1 vs) ps}vertmap             NB. new vertmap
end.
radius
)


NB. Builds the u-matrix (uniform distance matrix),
NB. the matrix of the average weight difference
NB. each vertex with each of its neighbour vertices.
umatrix=: 3 : 0
dis=. >((+/&.:*:)@:-)&.>/~ cmap                NB. distance of each point to other pts
th=. dis < 1.45 NB. less than %: 2+epsilon     NB. threshold, interested in distances less than %:2
vdist=. vertmap (+/&.:*:@:-)"1 _"_ 1 vertmap   NB. distances of each vertex to other vertices
>(+/ % +/@:>&0)@:,&.> <"2 th * vdist           NB. use th as mask, calculate avg distances
)


NB. Returns the distance to the given point, from
NB. each of the points in the map. The argument
NB. must have the correct shape and length.
NB. i.e. a 1-dimensional array of length equal to
NB. constructor argument vlen.
NB. Arguments:
NB. 0: point to calculate distance to.
NB. Example:
NB. >  som = (data;27;100;0.5;0.1) conew 'SOM'
NB. >  fit__som 1000
NB. >  ...
NB. >  distanceTo__som myPoint NB. here vlen = $ myPoint.
distanceTo=: 3 : 0 "1
'Argument is wrong shape' assert vlen=$y
vertmap (((+/&.:*:)@:-))"1 _ y
)


NB. Gives the coordinates of the closest point
NB. to the given input vector.
NB. Arguments:
NB. 0: input vector.
closestPoint=: 3 : 0 "1
(,cmap){~{.I.(=>./),distanceTo y
)

NB. Gives the coordinates of the closest point
NB. to the given input vectors.
NB. Arguments:
NB. 0: input vectors.
allClosestPoints=: 3 : 0"_
(~. ,: <"0@:#/.~) closestPoint y
)


NB. Plots the weight of each of each
NB. component of the layer's neuron vector.
plotSOMPlanes=: 3 : 0
map=.''
for_i. i. vlen do.
  viewmat i{"1 vertmap
end.
)

NB. performs k-means clustering on the weights of the SOM.
NB. This will group the weight matrix into the given number of
NB. clusters.
NB. Parameters:
NB. y: number of clusters. (known or estimated)
NB. x: number of iterations of kmeans.
kmCluster=: 4 : 0
k =. (( (,/vertmap));'euclidean';y; 'uniform') conew 'KMeans'
fit__k x
labels=: labels__k
clusterLabels=: (2^y) %~ #. labels__k

destroy__k ''
clusters=: dims $,clusterLabels
)


NB. Quantization Error, is a measure of the quality of training.
NB. Q.E. is the average distance from each datapoint to its closest
NB. point on the SOM.
NB. Arguments:
NB. 0: dataset to test Q.E. on.
NB. returns: Quantization error.
qError=: 3 : 0
(+/ % #) (<./@,@distanceTo)"1 y
)

NB. Topological Error, isa measure of the quality of training.
NB. T.E. is the fraction of datapoints whose nearest two SOM points are adjacent.
NB. Arguments:
NB. 0: dataset to test T.E. on.
NB. returns: Topological error.
tError=: 3 : 0
k=.,som
(#y) %~ +/ (((>@{.) (1.43&>@:(+/&.:*:@:-)) (>@{:))@:(2&{.)@:(k&/:)@,@distanceTo)"1 y
)

destroy=: codestroy


Note 'Example'
> X=: digits NB. use pen digits dataset
> som=:(X;(40 40);16;0.95;0.1)conew'SOM'
> fit__som 500
> NB. 10 centroids, 100 iterations of kmeans.
> 100 kmCluster__som 10
> NB. view clusters
> viewmat clusters__som
)
