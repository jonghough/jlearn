Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
) 

require jpath '~Projects/jlearn/trees/dtree.ijs'

coclass 'BaseRF'

create=: 3 : 0
'X Y batchSize maxDepth maxLeafCount info splitv'=: y
treeList=: ''
)

NB. Random Forest Classifier
coclass 'RFC'
coinsert 'BaseRF'

NB. Creates an instance of the RandomForestClassifier class.
NB. The RFC class uses a collection of tree classifiers to
NB. independently classify datapoints of the given dataset,
NB. and the forest classifies datapoints by taking the 
NB. most common classification form the collection of tree
NB. classifiers.
NB. Parameters:
NB. 0: Dataset
NB. 1: Data labels
NB. 2: batch size
NB. 3: Maximum depth of each tree
NB. 4: Maximum leaf count of each tree
NB. 5: Information criterion for each tree
NB. 6: split function of each tree.
create=: 3 : 0

(create_BaseRF_ f. ) y
)

NB. Fits the dataset 
fit=: 3 : 0
size=: y
assert. size > 0
for_i. i.size do.
  tr=. (maxDepth; maxLeafCount; info; splitv;1) conew 'jLearnTree'
  treeList=: treeList, tr
  index=. batchSize ?# X
  data=. index { X
  expected=. index { Y
  expected fit__tr data
end.
''
)


predict=: 3 : 0"1
pr=. ''
for_i. i.#treeList do.
  t=. i{treeList
  n=. <(=>./)predict__t y
  pr=. pr,n
end.
>{. (~.pr) \: (#/.~) pr
)


destroy=: 3 : 0
if. 0< # treeList do.
  try.
    for_j. i.#treeList do.
      t=. j{treeList
      destroy__t ''
    end.
  catch.
    smoutput 'Error destroying RFC.'
  end.
end.
codestroy ''
)

 