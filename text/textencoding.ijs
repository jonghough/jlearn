Note 0
Copyright (C) 2018 Jonathan Hough. All rights reserved.
)


cocurrent 'jLearnText'

 



splitText=: <.@:-:@:[ (({ ,"0 _"_ 0 ([ I.@:~: i.@:#@:]) { ]) ])"_ 1 [ ]\ ]
NB. Get all pairs as word vectors of length #x
NB. y: sentences to split into pairs of words
NB. x: list of unique words in the dictionary.
getPairs=: 4 : 0
x ="_ 0"_ 1[ 5 splitText y
)



subsample=: 3 : 0
'text sr'=.y
txt=. ;: text
n=. #txt
r=. (~. ,:  <"0@:(#/.~))  txt
t=. (%&n)>1{r
s=. (% * >:@:%:)@:(%&sr)  t
f=. r, <"0 s
rnd=. 3 : ' ? 0'
rem=. I.>(rnd < ])&.> (2{f) {~ txt i.~ {. f
rem{txt
)



NB. Parameters:
NB. 0: text to vectorize.
NB. 1: window size for text
NB. 2: output vector size.
NB. 3: Number of iterations for the NN to run.
NB. 4: Batch size per iteration of NN.
NB. 5: Learning rate
NB. 6: do Sub-sample
NB. 7: Sub-sameple rate.
vectorizeText=: 3 : 0
'text window outsize epochs batchSize lr doss sr'=.y
if. doss do.
txt=. subsample text;sr
else.
txt=. ;: text
end. 
words=. ~. txt
pairs=. words getPairs txt 
X=. ,/0{"2 pairs
Y=. ,/1{"2 pairs
size=. {:$X 
C=: ((size,outsize,size);'identity';'softmax'; lr; lr; epochs;'L2'; 'sgd';batchSize) conew 'MLPClassifier'
X fit__C Y
'w1 w2'=. weights__C
destroy__C '' 
txt;}:w1 NB. get rid of the bias node
)


0 : 0
Steps
1. Get text S. some sentences etc.
2. use getPairs to split it into pairs, with window
   size 5.
3. Use the first item of every pair as X, second as Y
4. create MLPClassifier with softmax output identity middle,
   and train X fit__C Y (or is it Y fit__C X?)
http://mccormickml.com/2016/04/19/word2vec-tutorial-the-skip-gram-model/
)