Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

Note 'References'
[0] Scikit-Learn scorer.py module.
)

NB. Largely based on  Scikit-Learn scorer.

cocurrent 'jLearnScorer'

hm=: # % (+/@:%) NB. harmonic mean

NB. Precision, Recall, Fscore.
NB. For each class, returns the value
NB. tp / (tp + fp),  where tp are
NB. the number of true positive predictions,
NB. and fp is the number of false positive
NB. predictions.
prf=: 3 : 0
'trueResults predResults beta'=. y

assert. beta > 0
assert. ($trueResults) -: $ predResults
NB. -1 indicates false positives (FP)
NB.  0 indicates true positives (TP)
NB.  1 indicates false negative (FN)

classes=. ~. trueResults
pc=. +/ classes-:"1 _"_ 1 predResults
tc=. +/ classes-:"1 _"_ 1 trueResults
fp=. (0:`(-@:])@.(<&0))"0 tc - pc
fn=. (0:`]@.(>&0))"0 tc - pc
tp=. pc - (fp)

prec=. tp % (tp + fp)
recall=. tp % (tp+fn)
beta2=. *: beta
fscore=. ((1+beta)*prec * recall) % (recall + beta2*prec)
prec;recall;fscore
)

NB. Creates a confusion matrix form the given true results
NB. and predicted results tuple (boxed pair of results).
NB. Input is assumed to be one-hot encoded labels for both
NB. true results and predicted results.
NB. Parameters:
NB. 0: true results matrix of one hot encoded values.
NB. 1: predicted results matrix of one hot encoded values.
NB. Returns:
NB.   confusion matrix.
NB.
NB. Example:
NB. True results, predicted results ar eshown below.
NB. 
NB.┌───────┬───────┐
NB.│1 0 0 0│1 0 0 0│
NB.│0 1 0 0│0 1 0 0│
NB.│0 1 0 0│1 0 0 0│
NB.│0 0 0 1│0 1 0 0│
NB.│1 0 0 0│0 0 0 1│
NB.│0 1 0 0│1 0 0 0│
NB.│0 0 1 0│0 1 0 0│
NB.│0 0 1 0│0 0 1 0│
NB.│0 0 0 1│0 0 1 0│
NB.│1 0 0 0│0 0 0 1│
NB.└───────┴───────┘
NB. 
NB. above trueResults, predResults pair will give a
NB. confusion matrix of
NB.
NB.1 0 0 2
NB.2 1 0 0
NB.0 1 1 0
NB.0 1 1 0
NB.
confusionMatrix=: 3 : 0
 (|:trueResults) (+/ .*) predicted Results
)

NB.┌───────────────────┬───────────────────┐
NB.│3 2 2 0 3 2 1 1 0 3│3 2 3 2 0 3 2 1 1 0│
NB.└───────────────────┴───────────────────┘
NB.
confusionMat=: 3 : 0
'trueResults predResults'=. y
classes=. ~. trueResults
pc=. +/ classes-:"1 _"_ 1 predResults
tc=. +/ classes-:"1 _"_ 1 trueResults
fp=. (0:`(-@:])@.(<&0))"0 tc - pc
fn=. (0:`]@.(>&0))"0 tc - pc
tp=. pc - (fp)
NB. TODO

)


NB. Explained Variance score for regression
NB. models.
explainedVariance=: 3 : 0
'trueResults predResults'=. y
'Size of sets does not match.' assert ($ predResults) = $ trueResults
'Not a regression set.' assert 1={:$predResults
avg=. '' $ (+/ % #), trueResults - predResults
n=: *: trueResults - predResults + avg
tavg=. '' $ (+/ % #), trueResults
d=. *: trueResults - tavg
sc=. 1 - n%d
sc=. 0 (I. sc e. _ __) } sc
(+/ % #) sc
)

