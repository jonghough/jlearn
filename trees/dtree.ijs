Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


Note 'References'
[0] Machine Learning - A Probabilistic Perspective, K. Murphy, Ch. 16

)


require jpath '~Projects/jlearn/trees/criterion.ijs'


NB. Decision Tree
NB. Implementation of Decision Tree Regressor and Classifier.
coclass 'jLearnTree'


NB. Queue used for building the decision tree. Tree is built iteratively
NB. by enqueing new nodes onto this queue, rather than depth-first
NB. recursion.
Q=: ''
NB. Minimum number of samples to split on.
minSamplesSplit=: 2
NB. Minimum weight fraction of leaf
minWeightFractionLeaf=: 1
NB. keeps the current leaf node count
currentLeafNodeCount=: 0
cp=: 1


NB. Instantiate a Learning Tree based on the CART algorithm.
NB. Params:
NB. 0: Max Tree Depth
NB. 1: Max Number of leaf ndoes
NB. 2: Information criteria. Can be either 'entropy' or 'gini'
NB. 3: Splitting point. Can be either 'random' or 'average'
NB. 4: random subspace flag. If true, then each iteration of
NB.    the decision tree algorithm will use a random subset of the
NB.    features.
NB. 
NB. Example:
NB. > myDT=: (10;100;'gini';'avg') conew 'jLearnTree'
NB. > Y fit__myDT X NB. X,Y are datapoints and target values, respectively.
create=: 3 : 0
'maxTreeDepth maxLeafNodes info splitv rsm'=: y

info=. tolower info
splitv=. tolower splitv
assert. maxTreeDepth > 0
assert. maxLeafNodes > 0
assert. (<info) e. 'gini';'entropy'
assert. (<splitv) e. 'a';'avg';'average';'r';'rand';'random'

if. info -: 'gini' do.
  informationMeasure=: giniCriterion_jLearnTreeUtil_
else.
  informationMeasure=: entropy_jLearnTreeUtil_
end.

if. (<splitv) e. 'a';'avg';'average' do.
  isRand=: 0
  splitVerb=: splitAvg_jLearnTreeUtil_
else.
  isRand=: 1
  splitVerb=: splitRand_jLearnTreeUtil_
end.

this=: coname ''
)


randomSubspace=: >:@:?@:<:@:# ? #

randomGain=: 3 : 0
'dataa classes'=. y
feature=: ?{.#"1 dataa
split=: (?@:# { ])feature{"1 data
feature;split
)

NB. Calculates the feature that has the maximum information gain
NB. for the given dataset.
calcMaxGain=: 3 : 0

'dataa classes'=. y
ss=. i.{:$dataa
if. rsm do.
ss=. randomSubspace i.{:$ dataa
end.
feature=. 1
classIndices=. ( ="_ 0 ~.) <"1 classes
S=: informationMeasure (+/"1 % #"1) classIndices
splits=. ''
d=. ''
for_i. ss do.
  set=. i{"1 dataa
  if. 1 = # ~. set do.
    splits=. splits,__
    d=. d, <__
  else.

    p=. splitVerb set
    splits=. splits,p
    ltIndex=. p> set
    gteIndex=. -. ltIndex
    
    ltE=. informationMeasure (+/"1 % #"1) (I. ltIndex) {"1 classIndices
    gtE=. informationMeasure (+/"1 % #"1) (I. gteIndex) {"1 classIndices
    d=. d, <S - (ltE+gtE)
  end.
end.
 
R=: d
G=: splits
ssi=.{.I. (=>./) > d NB. max gain index
mgi=. ssi{ss
mgi;(ssi{splits)
)



NB. Splits using the max gain feature.
removeMaxGainFeature=: 4 : 0
'feature split'=. x
'datxa classes'=. y

ltIndex=. split > feature{"1 datxa
gteIndex=. -. ltIndex

ltRemoved=. (gteIndex # datxa) ; (gteIndex)
gteRemoved=. (ltIndex # datxa) ; (ltIndex)

(<ltRemoved), (<gteRemoved)
)


NB. Builds the decision tree. Creates root node, and
NB. initializes the earning tree for use in fitting.
NB. This is called in the fit verb.
buildTree=: 3 : 0
data=. y
assert. -. (<'boxed') -: < datatype >data NB. do not accept boxed cells, everything must be numeric.

size=. <i. >{. #&.> data
mg=. calcMaxGain data
root=: (a:,mg,(size),<this) conew 'TreeNode'
self__root=: root
Q=: root
''
)

NB. Fit the training data. Creates the decision tree
NB. based on the training data, using the given
NB. evaluation function, either 'Information Gain',or
NB. 'Gini Index'.
NB. Parameters:
NB. x: Target data
NB. y: Input data.
NB.
NB. Example:
NB. > myTree=: (4;200;'gini'; 'avg') conew 'jLearnTree'
NB. > Targets fit__myTree X
fit=: 4 : 0
buildTree y;x
while. 0<# Q do.
  node=. {.Q
  Q=: }.Q
  bisect__node y;x
end.
)


NB. Predict the class from a single test datapoint.
NB. y: datapoint.
NB. returns: predicted class of the datapoint
predict=: 3 : 0 "1
predict__root y
)


destroy=: 3 : 0
try.
  if. root = '' do. codestroy ''
  else.
    destroy__root ''
  end.
catch. smoutput 'Exception destroying JLearnTree instance.'
end.
)


NB. Node Class can be either a leaf node or a non-leaf node.
NB. Each non-leaf node has a reference to its left and right
NB. child nodes.
coclass 'TreeNode'

NB. Instantiates an instance of TreeNode class.
NB. Params:
NB. 0: Parent Node.
NB. 1: Features
NB. 2: Score
NB. 3: Data indices of the original data that this
NB.    Node contains.
NB. 4: TreeHolder class reference. This is a reference to
NB.    the Tree class which encapsulates all the nodes of
NB.    the tree.
create=: 3 : 0
'parent feature score dataIndices treeHolder'=: y
class=: ''
self=: ''
depth=: 0 
 
if. cp__treeHolder do. bisect=: bisectClass
else. bisect=: bisectReg end.
''
)



NB. Bisects the current node's set of datapoints,
NB. assuming the decision tree is solving a regression problem.
bisectReg=: 3 : 0
mg=. feature;score
data=. (dataIndices&{)&.> y
if. depth (>+.=) maxTreeDepth__treeHolder do.
  NB. smoutput 'reached max depth'
  f=: (~.@:<"1) ,: (<"0@:#/.~)
  class=: (+/ % #) >{: data
  currentLeafNodeCount__treeHolder=: >:currentLeafNodeCount__treeHolder
  return.
end.
NB. check current node.
if.0= #>{: data do. return. end.
if.1= #>{: data do.
  class=: (+/ % #) >{: data
  return. end.

lr=: mg removeMaxGainFeature__treeHolder data

NB. L is left child.
subIndicesL=: I.>{:>0{lr
NB. R is r child.
subIndicesR=: I.>{:>1{lr
if.(0=#subIndicesR) +. 0=# subIndicesL do.
 f=: (~.@:<"1) ,: (<"0@:#/.~)
  class=: (+/ % #) >{: data
  currentLeafNodeCount__treeHolder=: >:currentLeafNodeCount__treeHolder
  return.
end.


lmg=. calcMaxGain__treeHolder (subIndicesL{dataIndices)&{&.>y
left=: ((<self),lmg,(<(subIndicesL{dataIndices)),<treeHolder) conew 'TreeNode'
self__left=: left
depth__left=: >:depth

NB. bisect__left y
Q__treeHolder=: Q__treeHolder,left


rmg=. calcMaxGain__treeHolder (subIndicesR{dataIndices)&{&.>y
right=: ((<self),rmg,(<(subIndicesR{dataIndices)),<treeHolder) conew 'TreeNode'
self__right=: right
depth__right=: >:depth
NB. bisect__right y
Q__treeHolder=: Q__treeHolder,right

)


NB. Bisects the current node's set of datapoints,
NB. assuming the decision tree is solving a classification problem.
bisectClass=: 3 : 0 
mg=. feature;score
data=: (dataIndices&{)&.> y
if. depth >: maxTreeDepth__treeHolder do.
  smoutput 'reached max depth'
  f=: (~.@:<"1) ,: (<"0@:#/.~)
  classes=. <"1>{: data
  classSizes=. #/.~ classes
  classNub=: ~.classes
  class=: {: classNub /: classSizes
  currentLeafNodeCount__treeHolder=: >:currentLeafNodeCount__treeHolder
  return.
end.

if.0= #>{: data do. return. end.
classes=: ~.<"1>{: data 
if. 1 = # classes do. 
  class=: classes
  currentLeafNodeCount__treeHolder=: >:currentLeafNodeCount__treeHolder
 return.
end. 
lr=: mg removeMaxGainFeature__treeHolder data

NB. L is left child.
subIndicesL=: I.>{:>0{lr
NB. R is r child.
subIndicesR=: I.>{:>1{lr
if.(0=#subIndicesR) +. 0=# subIndicesL do.
f=: (~.@:<"1) ,: (<"0@:#/.~)
  classes=. <"1>{: data
  classSizes=. #/.~ classes
  classNub=: ~.classes
  class=: {: classNub /: classSizes
  currentLeafNodeCount__treeHolder=: >:currentLeafNodeCount__treeHolder
  return.
end. 

lmg=. calcMaxGain__treeHolder (subIndicesL{dataIndices)&{&.>y
left=: ((<self),lmg,(<(subIndicesL{dataIndices)),<treeHolder) conew 'TreeNode'
self__left=: left
depth__left=: >:depth
NB. bisect__left y
Q__treeHolder=: Q__treeHolder,left


rmg=. calcMaxGain__treeHolder (subIndicesR{dataIndices)&{&.>y
right=: ((<self),rmg,(<(subIndicesR{dataIndices)),<treeHolder) conew 'TreeNode'
self__right=: right
depth__right=: >:depth
NB. bisect__right y
Q__treeHolder=: Q__treeHolder,right
)

NB. Predict the class from a single test datapoint.
NB. y: datapoint.
NB. returns: predicted class of the datapoint
predict=: 3 : 0 "1
f=. feature{"1 y
if. -. class -: '' do.
  c=. class
elseif. score > f do.
  c=. predict__right y
elseif. 1 do.
  c=. predict__left y
end.
,>c
)



destroy=: 3 : 0
try.
  destroy__left ''
  destroy__right ''
catch.
  smoutput 'Exception destroying tree nodes.'
end.
codestroy ''

)
 

NB. Decision Tree Regressor implementation. Uses CART-like cost function,
NB. using MSE.
coclass 'DTR'
coinsert 'jLearnTree'

NB. Instantiates an DTR instance.
NB. Parameters:
NB. 0: Maximum tree depth. Must be a positive integer
NB. 1: Maximum number of leaf nodes. Must be a positive integer.
NB.
NB. Example:
NB. > myDTR =: (5;100;'avg') conew 'DTR'
create=: 3 : 0
'maxTreeDepth maxLeafNodes splitv'=: y

splitv=. tolower splitv
assert. maxTreeDepth > 0
assert. maxLeafNodes > 0
assert. (<splitv) e. 'a';'avg';'average';'r';'rand';'random'

informationMeasure=: regCriterion_jLearnTreeUtil_


if. (<splitv) -: 'a';'avg';'average' do.
  splitVerb=: splitAvg_jLearnTreeUtil_
else.
  splitVerb=: randAvg_jLearnTreeUtil_
end.
cp=: 0 NB. not classification problem

this=: coname ''
)


calcMaxGain=: 3 : 0
informationMeasure y
)

destroy=: 3 : 0
destroy_jLearnTree_ f. ''
)
