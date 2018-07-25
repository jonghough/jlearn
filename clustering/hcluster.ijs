Note 0
Copyright (C) 2018 Jonathan Hough. All rights reserved.
)


Note 'References'
[1] Modern hierarchical, agglomerative clustering algorithms, Daniel Müllner
link: https://arxiv.org/pdf/1109.2378v1.pdf

[2] Methods of Hierarchical Clustering
link: https://arxiv.org/pdf/1105.0121.pdf
)

NB. Hierarchical Agglomerative clusterizer.
NB. HCluster class will perform hierarchical clustering on a given dataset, to
NB. partition the set into clusters.
NB. The operations work pairwise on all datapoints of the dataset, meaning that
NB. given N datapoints, we have, internally, an NxN distance matrix. For large
NB. datasets this may be impracitcal.
NB. The HCluster class has a choice of distance metrics, and linkage functions.
NB. Distance metrics may be euclidean, manhattan, max.
NB. Linkage functions may be single, complete, average.

require 'viewmat'

coclass 'HCluster'

dsq=: +/@:(*:@-)      NB. euclidean distance squared
manhattan=: +/@:|@:-  NB. manhattan distance
min=: I.@:(=<./)      NB. array minimum value

NB. Names of the metrics used.
M=: 'manhattan'
E=: 'euclidean'
NB. Distance metric can be any of
NB.	1. 'Euclidean'
NB.	2. 'Manhattan'
metric=: 'Euclidean'
isMetricDefinition=: 3 : '(M;E) e.~ < tolower y'

isLinkage=: 3 : 0
y=. <tolower y
y e. 'complete';'single';'average'
)


NB. Creates an instance of the Hierarchical Cluster class.
NB. Parameters:
NB. 0: data - dataset to use. This should be of shape (sample_size x feature_size).
NB. 1: metric - the distance metric to use. May be one of:
NB.    'euclidean'
NB.    'manhattan'
NB. 2: linkage - the linkage to use. May be one of:
NB.    'single'    - for single linkage (take min distance between cluster pairs)
NB.    'complete'  - for complete linkage (take max distance between cluster pairs)
NB.    'average'   - for average linkage (take average distacne between cluster pairs)
NB.
create=: 3 : 0
'data metric linkage k'=: y
'Metric must be Euclidean or Manhattan' assert (isMetricDefinition metric)
'Linkage type must be Complete, Average or Single' assert (isLinkage linkage)
if. metric -: 'euclidean' do. distFunc=: dsq
else. distFunc=: manhattan end.
if. linkage -: 'single' do. linkageFunc=: fitSingleLinkage
elseif. linkage -: 'complete' do. linkageFunc=: fitCompleteLinkage
elseif. 1 do. linkageFunc=: fitAverageLinkage end.
''
)

NB.
fit=: 3 : 0
linkageFunc ''
)

NB. Fit the data to clusters using Single Linkage. At each
NB. iteration the shortest distance between any pair of points
NB. from different clusters dictates the merger of those clusters.
fitSingleLinkage=: 3 : 0
NB. cluster until required number of clusters is found.
clusters=: i. # data NB. initialize to individual clusters.
ds=: data (distFunc)"1 _"_ 1 data
ds=: ds (*`]@.(_&-:@]))" 0 0 %<"0 1~i.#ds
L=: ''
Ks=: ,:clusters
while. 1 do.
  next=: ,&.> {. _2<\ ,/($ #: I.@:,) ds=<./<./ ds
  cl=: I.&.> <"1 (~.@:[ ="0 _ ])/~ clusters
  na=: ,>next
  L=: L,<next
  op=: ({: na) { clusters
  idxs=: I.clusters = ({: na) { clusters
  selected=: ((<./na){clusters)
  cidxs=: I.clusters = selected
  if. selected<:op do.
    clusters=: selected idxs } clusters
  else.
    clusters=: op cidxs } clusters
  end.
  Ks=: clusters,Ks
  infs=: cidxs (<@:,)"0 0"_ 0 idxs
  ds=: _ infs} ds
  if. k>:#~.clusters do. break. end.
end.
)

NB. Fit the data to clusters using Complete Linkage. At each
NB. iteration the cluster distances is measured by the largest distance
NB. between points from cluster pairs. The smallest such cluster
NB. distance dictates the merger of the clusters.
fitCompleteLinkage=: 3 : 0
clusters=: i. # data
ds=: data (distFunc)"1 _"_ 1 data
ds=: ds (*`]@.(_&-:@]))" 0 0 %<"0 1~i.#ds
L=: ''
Ks=: ,:clusters
last=: <:#data
while. 1 do.
  cl=: I.&.> <"1 (~.@:[ ="0 _ ])/~ clusters 
  mindist=: ((([ (I.@:= ; ]) <./)@:((]`-@.(__&-:))"0)@:(>./)@:((]`-@.(_&-:))"0)@:{&ds)@:(-.&last))&.>cl
  next=: ([ (cl&({~)@:I.@:= ; ]) ( ((]`[@.(<&:(>@:{:)))&.>)/)) mindist
  na=: ({.,>>{. next), (,{.>{.>{:next)
  L=: L,<next
  op=: ({: na) { clusters
  idxs=: I.clusters = ({: na) { clusters
  selected=: ((<./na){clusters)
  cidxs=: I.clusters = selected
  if. selected<:op do.
    clusters=: selected idxs } clusters
  else.
    clusters=: op cidxs } clusters
  end.
  Ks=: clusters,Ks
  infs=: cidxs (<@:(/:~)@:,)"0 0"_ 0 idxs 
  ds=: _ infs} ds
  if. k>:#~.clusters do. break. end.
end.
)

NB. Fit the data to clusters using Complete Linkage. At each
NB. iteration the cluster distances is measured by the average distance
NB. between points from cluster pairs. The smallest such cluster
NB. distance dictates the merger of the clusters.
fitAverageLinkage=: 3 : 0
clusters=: i. # data
ds=: data (distFunc)"1 _"_ 1 data
ds=: ds (*`]@.(_&-:@]))" 0 0 %<"0 1~i.#ds
L=: ''
Ks=: ,:clusters
last=: <:#data
while. 1 do.
NB. indices of clusters. We can find the max distance
  cl=: I.&.> <"1 (~.@:[ ="0 _ ])/~ clusters

  mindist=: ((_&+@:1:)`((([ (I.@:= ; ]) <./)@:((+/ % #))@:{&ds))@.(*@:#)@:(-.&last))&.>cl

  next=: ([ (cl&({~)@:I.@:= ; ]) ( ((]`[@.(<&:(>@:{:)))&.>)/)) mindist
  na=: ({.,>>{. next), (,{.>{.>{:next)
  L=: L,<next
  op=: ({: na) { clusters
  idxs=: I.clusters = ({: na) { clusters
  selected=: ((<./na){clusters)
  cidxs=: I.clusters = selected
  if. selected<:op do.
    clusters=: selected idxs } clusters
  else.
    clusters=: op cidxs } clusters
  end.
  Ks=: clusters,Ks
  infs=: cidxs (<@:,)"0 0"_ 0 idxs
  ds=: _ infs} ds
  if. k>:#~.clusters do. break. end.
end.
)

fitWardLinkage=: 3 : 0
clusters=: i. # data
ds=: data (distFunc)"1 _"_ 1 data
ds=: ds (*`]@.(_&-:@]))" 0 0 %<"0 1~i.#ds
cp=: ds NB. copy, immutable.
L=: ''
Ks=: ,:clusters
while. 1 do.
NB. indices of clusters. We can find the max distance
  cl=: I.&.> <"1 (~.@:[ ="0 _ ])/~ clusters
  counts=: (~. ,: #/.~ ) cl
  mindist=: (([ (I.@:= ; ]) <./)@:((+/ % #))@:{&ds)&.>cl
  next=: ([ (cl&({~)@:I.@:= ; ]) ( ((]`[@.(<&:(>@:{:)))&.>)/)) mindist
  na=: ({.,>>{. next), (,{.>{.>{:next)
  L=: L,<next
  op=: ({: na) { clusters
  idxs=: I.clusters = ({: na) { clusters
  selected=: ((<./na){clusters)
  cidxs=: I.clusters = selected
  if. selected<:op do.
    clusters=: selected idxs } clusters
  else.
    clusters=: op cidxs } clusters
  end.
  Ks=: clusters,Ks
  infs=: cidxs (<@:,)"0 0"_ 0 idxs
  ds=: _ infs} ds
  if. k>:#~.clusters do. break. end.
end.

NB. do this at each iteration
((#~ </"1)@(#: i.@:(*/))@:(2&#)@:# { ])@:/:~
q=: r cl NB. we have pairs of each cluster
sicd=: +/@:(0:`(({&cp)@:<"1)@.((0&<)@:#))&.> q NB. sum of intra cluster distances.
''
)

standardizeColumns=: 3 : 0
colMeans=: mean y
colStd=: stddev y
res=: y -"1 1 colMeans
res %"1 1 colStd
)
NB. Destandardizes the input. Assumes the input is
NB. standardized data with each feature having
NB. mean, variance = 0,1
NB. y: standardized dataset
destandardize=: 3 : 0
colMeans + y * colStd
)

destroy=: codestroy



0 : 0

hc =: (X;'average') conew 'HCluster'
fit__hc ''
q=:(|:@:(2&{."1)@:{&data)&.> cl
pd 'reset'
   pd 'type marker'
   pd <"1 >0{q
   pd 'show'
    pd <"1 >1{q
   pd 'show'
    pd <"1 >2{q

   pd 'show'


rtc=: '┐'
   rbc=: '┘'
   lbc=: '└'
   ltc=: '┌'
   ct=: '┬'
   cb=: '┴'

   hc=: (X;'euclidean';'complete';3) conew 'HCluster'

 viewmat Ks__hc /:~"1 i.#Ks__hc
   viewmat  /:~"1  Ks__hc
viewmat (|:normalizecolumns_jLearnUtil_ |: /:~"1 Ks__hc)
)