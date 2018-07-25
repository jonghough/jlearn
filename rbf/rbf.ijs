Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

NB. Radial Basis Function Networks for Classification and Regression.


load jpath '~Projects/jlearn/clustering/kmeans.ijs'

coclass 'RBFBase'
dot=: +/ . *
pinv=: |: dot~ %.@:(|: dot ])

create=: codestroy




NB. Radial Basis Function Network for classification implementation.
NB.
NB. Example usage:
NB. rbf =: (input;target;10) conew 'RBFClassifier'
NB. input and target are the input and target arrays, resp.
NB. The third parameter is the number of basis functions to use.
NB.
NB. fit__rbf ''
NB. This will train the RBF-network's weight matrices (input-hidden weights,
NB. and hidden-output weights).
NB.
NB. predict__rbf"1 testdata
NB. This will tes tthe network's accuracy and give the output for each row
NB. of the test input values, testdata.

 
coclass 'RBFClassifier'
coinsert 'RBFBase'

NB. Create a new instance of the RBF Network Classifier.
NB. Parameters:
NB. 0: input dataset
NB. 1: target data for the input dataset
NB. 2: Number of nodes to use in the hidden layer.
NB. 3: Multiplier for the radial basis function exponent.
create=: 3 : 0
'inputs targets nRBF multiplier'=: y
assert. nRBF > 0
assert. multiplier > 0
weights1=: (nRBF ? 0{ $ inputs) { inputs       NB. in-hidden weights
weights2=: ''                                  NB. hidden-out weights
gbf=: ^@:(+/"1) @:(*&multiplier)@:-@:*:@:-     NB. gaussian basis fn
''
)

NB. Trains the RBF network. Take a subsample of the training
NB. data.
fit=: 3 : 0
hidden=: 1,~"1 inputs gbf"1 1"1 _ weights1
NB. use the pseudoinverse of the hidden matrix
NB. to get the output weight matrix.
weights2=: ( pinv hidden) dot targets
''
)

NB. Predict the output given some test input data.
NB. Parameters:
NB. 0: test datapoints to predict the output values for.
predict=: 3 : 0 "_
(1,~"1 y gbf"1 1"1 _ weights1) dot weights2
)



NB. Gives an score of the neural net, based on its
NB. accuracy on estimating the results for the given
NB. test data.
NB. x: test data target values
NB. y: test data input set
NB. returns:
NB. score in range [0,1], where 1 is perfect
NB. accuracy.
score=: 4 : 0 "_
assert. x (-:&:({.@:$)) y
vdata=. predict y
(# y) %~ +/x -:"1 1 (=>./)"1 vdata
)

getAvgError=: 4 : 0
vdata=. validate y
(+/ % #) | , x -"1 1 vdata
)

destroy=: codestroy


NB. Radial Basis Function Network Regressor.
coclass 'RBFRegressor'
coinsert 'RBFBase'

NB. Create a new instance of the RBF Network Regressor.
NB. Parameters:
NB. 0: input dataset
NB. 1: target data for the input dataset
NB. 2: Number of nodes to use in the hidden layer.
NB. 3: Multiplier for the radial basis function exponent.
NB. 
NB. Example:
NB. > NB. X,y are training set, targets
NB. > NB. Z,t are test set and target
NB. > rbfr=: (X;y;100;4.5) conew 'RBFRegressor'
NB. > fit__rbfr ''
NB. > load 'plot' NB. plot test results against learned test results
NB. > plot |: t ,. predict__rbfr Z
NB. 
create=: 3 : 0
'inputs targets nRBF multiplier'=: y
'Input data must be 2 dimensional.' assert 2=$inputs
'Target data must be 2 dimensional.' assert 2=$targets
assert. nRBF > 0
assert. multiplier > 0
weights1=: (nRBF ? 0{ $ inputs) { inputs       NB. in-hidden weights
weights2=: ''                                  NB. hidden-out weights
gbf=: ^@:(+/"1) @:(*&multiplier)@:-@:*:@:-     NB. gaussian basis fn
''
)

NB. Trains the RBF network. Take a subsample of the training
NB. data.
fit=: 3 : 0
hidden=: 1,~"1 inputs gbf"1 1"1 _ weights1
weights2=: ( pinv hidden) dot targets
''
)


NB. Predict the  target values for the given input, based
NB. on the trained RBF network. 
predict=: 3 : 0 "_
(1,~"1 y gbf"1 1"1 _ weights1) dot weights2
)


destroy=: codestroy