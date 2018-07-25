Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 'References'
[1] Multi-class AdaBoost, 2006, Zhu, Rosset, Zou, Hastie
link: https://web.stanford.edu/~hastie/Papers/samme.pdf

[2] Scikit-Learn implementation of AdaBoost
link: https://github.com/scikit-learn/scikit-learn/blob/0.19.X/sklearn/ensemble/weight_boosting.py

[3] Machine Learning - A Probabilistic Perspective, K. Murphy, Ch. 16
)


coclass 'AdaBooster'

NB. Creates an instance of AdaBooster Classifier.
NB. AdaBooster uses SAMME algorithm on the collection
NB. of weak classifiers.
NB. Arguments:
NB. 1: Dataset input values
NB. 2: Target values of the dataset
NB. 3: learning rate
NB. 4: classifier type. Either 'MLP' or 'Tree'.
create=: 3 : 0
'X Y lr classifier'=: y
Wp=: (1&(,~)@:# $ %@:#)X     NB. append weights
cs=: ''
classifier=: tolower classifier
assert. (<classifier) e. 'mlp';'tree'
if. classifier -: 'mlp' do. classifierName=: 'MLPClassifier'
else. classifierName=: 'jLearnTree'
end.
)


NB. Sets the classifier arguments for
NB. the weak classifier constructors.
setClassifier=: 3 : 0
if. (<classifier)-: <'mlp' do.
  assert. 9=#y
else.
  assert. 5=#y
end.
cargs=: y
)

fit=: 3 : 0
max=: y
if. max < 1 do. max=: 1 end.
for_i. i. max do.
  class=. cargs conew classifierName
  cs=: cs,class
  usedC=: max
end.
W=. ''
EW=: '' NB. estimator weight
nclasses=. # ~. Y
for_i. i. max do.
  C=. i{cs
  Y fit__C X
  P=. (=>./)"1 predict__C X
NB. incorrect (see line 549)
  I=. -. Y-:"1 1 P
NB. avg error
  e=. ''$ (+/ Wp * I) % +/ Wp
  if. e >: 1 do.
    break. end.
  if. e <: 0 do.
    cs=. i{.cs
    break. end.
  a=. (^. (1-e) % e) + ^. nclasses - 1
  
  EW=: EW, lr * a
  w=. (Wp * ^ a * I)
  W=. W,<w
  Wp=. w
end.
)


NB. Predicts the class of the given datapoint(s),
NB. using the pretrained weak classifiers.
NB. Arguments:
NB. 0: Datapoint
NB. returns: Predicted classes
predict=: 3 : 0
pred=: 0
for_i. i.#cs do.
  C=: i{cs
  pred=: pred + (>i{EW) * predict__C y
end.
sum=: +/ EW
pred=: pred % sum
)

destroy=: 3 : 0
if. 0< # cs do.
  try.
    for_j. i.#cs do.
      c=. j{cs
      destroy__c ''
    end.
  catch.
    smoutput 'Error destroying AdaBooster.'
  end.
end.
codestroy ''
)
