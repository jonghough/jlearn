Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 'References'
[1] https://www.ri.cmu.edu/pub_files/pub1/moore_andrew_1991_1/moore_andrew_1991_1.pdf
)


NB. K-d Tree implementation. K-d trees partition space into more or less equal sized
NB. subspaces, with median values of chosen features given as the partitions.
NB. K-d trees can be  searched in NlogN time. Dataset is assumed to be normalized.
coclass 'KDTree'
median=: <.@-:@# { /:~
splitMedian=: ((;~-.)@:<~ median) (I.@:[ { ])&.> <
medianFeature=: (<.@-:@:# { ])@:({"1 /:~ ]) NB. dyadic, median on feature x, data y
splitMF=: (;~-.)@:(({"1 ) < ([ { medianFeature))
allNodes=: ''
distance=: ((+/&.:*:)@:-)
Q=: ''


NB. Instantiates an instance of KDTree class.
NB. Parameters:
NB. 0: data, the dataset to perform kdtree partitioning on.
NB.    The dataset is assumed to be normalized.
NB. 1: The maximum depth to use in partitioninng.
create=: 3 : 0
'data depth'=: y
self=: coname ''
build data
)


NB. Builds the KD-tree. This is called in the constructor.
NB. Parameters:
NB. 0: data, dataset to use.
build=: 3 : 0
data=: y
d=. depth
idx=: i. # data
cd=. 0
root=: ((<self), a:,(<i.#data)) conew 'KDTreeNode'
allNodes=: allNodes,root
Q=: Q,root
while. #Q do.
  if. 0< # Q do.
    next=. {.Q
    Q=: }. Q
    if. depth__next = depth do.
      break.
    elseif. indices__next = 1 do.
      continue.
    elseif. 1 do.
      split__next ? 4
    end.
  end.
  cd=. cd+1
  if. cd = depth do. break. end.
end.

)

NB. Searches the KD-tree for the closest point to the given point.
NB. The search can be performed in LogN time in principle, as opposed to
NB. N time for KNN.
NB. Parameters:
NB. y: Datapoint to find the nearest point to.
NB. returns:
NB.   boxed pair. First item is the index of the closest point in the
NB.   tree's dataset. The second is the distance of this point to y.
NB.
NB. Example:
NB. > search__kdTree 0 0.4 0.25 0.74 0.22
NB. >
NB. > ┌──┬─────────┐
NB. > │40│0.01202  │
NB. > └──┴─────────┘
search=: 3 : 0"1
node=: root
d=. _
sQ=. ''
while. 1 do.
  if. leftChild__node -: '' do.
    d=. (<./ (({&indices__node)@:I.@:=;[) ]) ( data {~ indices__node) distance"1 _ y 
    break.
  else.
    sQ=. sQ,node
    if. (idx__node{medianPt__node{data)<:idx__node{y do.
      node=: rightChild__node
    else.
      node=: leftChild__node
    end.
    
  end.
end.
sQ=. sQ
while. #sQ do.
  n=. {.sQ
  M=: n
  sQ=. }.sQ
  dm=. (<./ (({&indices__n)@:I.@:=;[) ]) ( data {~ indices__n) distance"1 _ y
  if. (>{:d)> >{:dm do. 
    d=. dm
  end.
end.
d
)



destroy=: 3 : 0
if. 0 < # allNodes do.
  for_i. allNodes do.
    a=. i{allNodes
    destroy__a ''
  end.
end.
codestroy ''
)


NB. =========================================================


NB. Node class for KDTree.
coclass 'KDTreeNode'
medianFeature=: (<.@-:@:# { ])@:({"1 /:~ ]) NB. dyadic, median on feature x
splitMF=: (;~-.)@:(({"1 ) < ([ { medianFeature))


NB. Creates an instane of 'KDTreeNode'.
NB. Parameters:
NB. 0: tree reference
NB. 1: parent node reference
NB. 2: indices of the tree reference's dataset to use
NB.    in this node.
create=: 3 : 0
'tree parent indices'=: y
self=: coname ''
leftChild=: ''
rightChild=: ''
depth=: 0
)

NB. split the dataset y on feature x.
split=: 3 : 0
idx=: y
medF=: medianFeature indices { data__tree
medianPt=: {.I. (idx{"1 data__tree) = idx{medF
s=. I.&.> y splitMF indices { data__tree
leftChild=: ((<tree),(<self),{.s) conew 'KDTreeNode'
rightChild=: ((<tree),(<self),{:s) conew 'KDTreeNode'
depth__leftChild=: depth+1
depth__rightChild=: depth+1
allNodes__tree=: allNodes__tree,leftChild,rightChild
Q__tree=: Q__tree,leftChild,rightChild
)

destroy=: codestroy