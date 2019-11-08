Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


NB. ================ Utility verbs ====================
NB. This collection of verbs is mainly concerned with
NB. the manipulation of data.
NB. 
NB. Example: Want to load a dataset.
NB.
NB. Let's load the iris dataset, from the datasets directory.
NB. > 'X Y' =: readCSV_jLearnUtil_ jpath '~Projects/jlearn/datasets/iris.csv'
NB. Here, X is the input data (feature set), and Y is the result data, which, in 
NB. this case, is the one-hot encoded classes of irises.
NB. 
NB. We want to split the data into training, validation, test sets:
NB. > 'Xtr Ytr Xv Yv Xte Yte' =:splitDatasetWithValidation_jLearnUtil_ X;Y;1.2;0.1;1
NB. Here (Xtr, Ytr) are the training X,Y data, (Xv,Yv) are validation, and
NB. (Xte, Yte) are test data.
require 'csv'

cocurrent 'jLearnUtil'


variance=: (+/@(*:@(] - +/ % #)) % #)"1
columnmean=: +/ % #
dot=: +/ .*
cov=: ((|:@:[dot])/~@:(-"1 1 columnmean) % (<:@:# ))                NB. covariance
require 'stats'
stdprb=: normalprob_base_ @: ((0 1 __)&,)
normalizecolumns=: (] -"1 1 (<./"2)) %"1 1 (>./"2) -" 1 1 (<./"2)


NB. Box-Muller transform implementation.
NB. Arguments:
NB. x: number of samples to take
NB. y: normal distribution mean and standard deviation.
bmt=: 4 : 0
'mean std'=. y
U1=. ? x # 0
U2=. ? x # 0
cos=. 2&o.
sin=. 1&o.
PI2=. o.2
z0=. (cos PI2 * U2) * %: _2 * (^. U1)
z1=. (sin PI2 * U2) * %: _2 * (^. U1)
mean + std * z0
)

NB. =========================================================
NB. loading csv / data
NB. =========================================================

NB. Reads the csv and returns the data in two boxed matrices.
NB. The left matrix being the input data, X, where each
NB. row of X is a datapoint. The right matrix is the
NB. target data, with vectorized output.
NB.   x: column index of target data.
NB.   y: path to csv file.
NB.   returns: (X,Y) boxed pair.
NB. example:
NB. >  Data=: 4 readCSV 'path/to/iris.csv'
readCSV=: 4 : 0
d=. readcsv y 
if. d -: _1 do.
smoutput 'Dataset not found. Check file path.' 
throw. 
end.
Xs=. makenum (x -.~ i. {: $ d) {"1 d
Ys=. >vectorize x {"1 d
Xs;Ys
)

NB. Reads the csv and returns the data in two boxed matrices.
NB. The left matrix being the input data, X, where each
NB. row of X is a datapoint. The right matrix is the
NB. target data, with normalized output.
NB.   x: column index of target data.
NB.   y: path to csv file.
NB.   returns: (X,Y) boxed pair.
NB. example:
NB. >  Data=: 4 readCSVR 'path/to/regression_data.csv'
readCSVR=: 4 : 0

'ti rt'=: x NB. target index, remove title flag.
if. rt = 0 do.
  d=: readcsv y
  smoutput $ d
else.
  d=: }. readcsv y
  smoutput $ d
end.
Xs=. makenum ( ti -.~ i. {: $ d) {"1 d
dims=. $ Xs
Ys=. (1,~{.dims)$>normalizecolumns makenum ti {"1 d
Xs;Ys
)

readData=: 4 : 0
Xs=. (x -.~ i. {: $ y) {"1 y
Ys=. >vectorize x {"1 y
Xs;Ys
)

NB. Vectorizes the labels of input y, into
NB. numeric 1, 0 vectors. This is useful
NB. for relabeling target data into numeric
NB. values, using one-hot encoding.
NB.   y: data column to vectorize.
NB.   returns: vectorized equivalent column.
NB. example:
NB. vectorize 3 1 $ 'Cat';'Dog';'Cat'
vectorize=: 3 : 0
vec=. <"1@:(#:@:(2&^)@:i.@:#@:~.)
convert=. $ $ (~. i. ]) { vec
convert y
)


NB. Numberizes the labels of input y, into
NB. integer numbers representing each catergory
NB. in the original data.
NB. y: data column to numberize
NB. example:
NB. numberize 7 1 $ 'Cat';'Dog';'Cat';'Pig';'Cow';'Fish';'Pig'
NB. This will return a single column of integers, where each number
NB. represents the respective class from the animal names.
numberize=: 3 : 0
convert=. $ $ (~. i. ]) { i.@:#@:~.
convert y
)

NB. Replaces the columns by 1-hot vector
NB. representing each catergory present in the
NB. column.
NB. x: list of column indices to replace with numerical vectors
NB. y: Dataset to transform.
NB.
NB. Example:
NB.
vectorColumnReplace=: 4 : 0"1 2
NB.if. 2>#$x do. x=. ,: x end.
smoutput #$x
smoutput x
vecs=: vectorize"1&.|: x{"1 y
vecs x}"1 y
)

NB. Replaces the columns by integer values
NB. representing each catergory present in the
NB. column.
NB. x: list of column indices to replace with numerical vectors
NB. y: Dataset to transform.
NB.
NB. Example:
NB.
numberColumnReplace=: 4 : 0"1 2
if. 2>#$x do. x=. ,: x end.
num=: <"0 numberize"1&.|: x{"1 y
num x}"1 y
)


dropColumn=: 4 : ' y{"1~ x-.~ i.{:$ y'

insertInColumn=: 4 : 0"0 2
assert. ''=$x NB. only accept single column inde
r=. {:$y
(x{."1 y) ,"1 (-r-x+1){."1 y
)

NB. Shuffle data. e.g. it may be useful to
NB. shuffle a dataset to randomize the order
NB. of datapoints.
shuffle=: {~ ?~@#

NB. splits the data set (inputs; targets)
NB. into training and test sets.
NB. Example: splitDataset_jLearnUtil_ data,(0.5;1)
NB. will split the dataset into 50% training and 50%
NB. test data.
NB. y: inputdata, targetdata,percentTrain, flag for
NB. normalization. If 1 then input data will be
NB. normalized.
NB. Example:
NB. >  NB. The returned data is, respectively,
NB. >  NB. train input, train target, test input, test target
NB.
NB. >  'ti tt tei tet' = splitDataset_jLearnUtil_ X;Y;0.4;1
splitDataset=: 3 : 0
'input target trainpc norminputs'=. y

assert. (# input)-: # target
shufflePerm=. (?~@#) input
input=. shufflePerm { input
target=. shufflePerm { target

if. norminputs do.
  input=. normalizecolumns input
end.

if. trainpc > 1 do. trainpc=. 1 elseif. trainpc<0 do. trainpc=. 0 end.
trainsplit=: i.@<.@(*&trainpc)@# { ]
testsplit=: (i.@:# -. (i.@<.@(*&trainpc)@#)) { ]

traindata=: trainsplit&.> (input; target)
testdata=: testsplit&.> (input; target)

traindata,testdata
)

NB. Splits the dataset and targetset into training,
NB. validation and testing subsets, respectively.
NB. The data will be shuffled.
NB. Params:
NB. 0: Input data
NB. 1: Target data
NB. 2: training percent (expressed in range [0,1])
NB. 3: validation percent (expressed in range [0,1])
NB. 4: normalize inputs flag. If true input columns will
NB.    be normalized.
NB. If the sum of training percent and validation percent
NB. exceeds 1, then the operation will fail.
NB. Example:
NB. >  NB. The returned data is, respectively,
NB. >  NB. train input, train target, valid. input, valid. target, test input, test target
NB.
NB. >  'ti tt vi vt tei tet' = splitDatasetWithValidation_jLearnUtil_ X;Y;0.4;0.2;1
splitDatasetWithValidation=: 3 : 0
'input target trainpc validpc norminputs'=. y 
'sum of percentages must not exceed 1.' assert 1>:trainpc + validpc
'length of input and target data must be equal.' assert (# input)-: # target

shufflePerm=. (?~@#) input
input=. shufflePerm { input
target=. shufflePerm { target

if. norminputs do.
  input=. normalizecolumns input
end.

if. trainpc > 1 do. trainpc=. 1 elseif. trainpc<0 do. trainpc=. 0 end.
if. validpc > 1 do. validpc=. 1 elseif. validpc<0 do. validpc=. 0 end.

testpc=. 1 - (trainpc + validpc)

s=. trainpc, validpc,testpc
part=. -.~&.>/\@:(i.&.>"0@:<"0)@:}.@:>.@:((+/\ - ])@:[ (* , ]) #@:])
indices=. s part i.#input

'tri vai tei'=. indices {&.> <input
'trt vat tet'=. indices {&.> <target

tri;trt;vai;vat;tei;tet
)

findNonNumericColumns=: 3 : 0
numer=. (".@:":)&.>
nn=. ''
for_i. i.{:$ y do.
  try.
    numer"0 i{"1 y
  catch.
    smoutput 'error at  ',": i
    nn=. nn,i
  catchd.
    smoutput 'errord at  ',": i
    nn=. nn,i
  catcht.
    smoutput 'errort at  ',": i
    nn=. nn,i
    
  end.
end.
nn
)

NB. TODO
removeIncomplete=: 3 : 0
smoutput '¯\_(ツ)_/¯'
)