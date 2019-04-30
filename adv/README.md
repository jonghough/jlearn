# Neural Network Pipeline  

Modular NN building blocks. The `NNPipeline` class can contain serveral different types of neural
network layer

* SimpleLayer - Fully connected neural network layer
* LSTMLayer - Long Short-Term Memory layer, used for sequential inputs.
* BasicRNNLayer - Basic RNN layer, used for sequential input
* Conv2D - 2D Convolutional layer 
* PoolLayer - Pooling layer, used with Conv2D layers. Strictly not a neural network layer.
* FlattenLayer - used to flatten outputs from previous layers into 2-D shapes. Strictly not a nn
layer

***

## Pipeline

`NNPipeline` is a contianer class which contains a sequence of the above layers.

## Simple Network

A simple network of fully connected layers can be used to solve classification and regression problems.
Example using iris dataset.

The dataset has 4 features, so the input should have dimension 4. The output has 3 possible classes,
so it is preferrable to use *softmax* output with 3 nodes.

```j
pipe=: (10;20;'softmax';1) conew 'NNPipeline'
N1 =: (4;10;'tanh';'sgd';0.01) conew 'SimpleLayer'
B1=: (0; 1 ;0.0001;10;0.01)  conew 'BatchNorm'
A1=: 'tanh' conew 'Activation'

N2 =: (10;5;'tanh';'sgd';0.01) conew 'SimpleLayer'
B2=: (0; 1 ;0.0001;5;0.01)  conew 'BatchNorm'
A2=: 'tanh' conew 'Activation'

N3 =: (5;5;'tanh';'sgd';0.01) conew 'SimpleLayer'
B3=: (0; 1 ;0.0001;5;0.01)  conew 'BatchNorm'
A3=: 'tanh' conew 'Activation'

N4 =: (5;3;'softmax';'sgd';0.01) conew 'SimpleLayer'
B4=: (0; 1 ;0.0001;3;0.01)  conew 'BatchNorm'
A4=: 'softmax' conew 'Activation'

addLayer__pipe N1
addLayer__pipe B1
addLayer__pipe A1

addLayer__pipe N2
addLayer__pipe B2
addLayer__pipe A2

addLayer__pipe N3
addLayer__pipe B3
addLayer__pipe A3

addLayer__pipe N4 
addLayer__pipe B4
addLayer__pipe A4

trainingTargets fit__pipe trainingData
```
We can then run predictions on test data using
```
predict__pipe testData
```
***

## Convolutional Network

Convolution layers have been implemented for 2D convolutions, and only for FULL 
convolutions.

***
### Example
Example to build a 2d convolution network. 
This example will create a very simple network to differentiate horizontal lines form vertical lines.

The pipeline consists of the following sequence of layers
`conv2d --> pool --> conv2d --> flat --> fully-connected`

The input consists of 8x8 "images", of 3 channels (rgb say). The whole dataset of size N is input
so the initial input should have shape Nx3x8x8.

```j
NB. create the "images"
A1=: 3 8 8 $ 1 1 1 1 1 1 1 1, 0 0 0 0 0 0 0 0
A2=: 3 8 8 $ 1 1 1 1 1 1 1 1, 0 0 0 0 0 0 0 0, 1 1 1 1 1 1 1 1, 1 1 1 1 1 1 1 1, 0 0 0 0 0 0 0 0
A3=: 3 8 8 $ 1 1 1 1 1 1 1 1, 0 0 0 0 0 0 0 0, 0 0 0 0 0 0 0 0
A4=: 3 8 8 $ 1 1 1 1 1 1 1 1, 0 0 0 0 0 0 0 0, 0 0 0 0 0 0 0 0, 1 1 1 1 1 1 1 1, 1 1 1 1 1 1 1 1, 0 0 0 0 0 0 0 0
A5=:  2 |. A4

B1=: |:"2 A1
B2=: |:"2 A2
B3=: |:"2 A3
B4=: |:"2 A4
B5=: |:"2 A5

A=: 5 3 8 8 $, A1, A2, A3, A4, A5
B=: 5 3 8 8 $, B1, B2, B3, B4, B5
INPUT=: A,B
OUTPUT=: 10 2 $ 1 0 1 0 1 0 1 0 1 0, 0 1 0 1 0 1 0 1 0 1

pipe=: (5;10;'softmax';1) conew 'NNPipeline'
p1=: 2 conew 'PoolLayer'
c1=: ((10 3 4 4);2;'relu';'adam';0.01;0) conew 'Conv2D'
b1=: (0; 1 ;0.0001;10;0.01) conew 'BatchNorm2D'
a1=: 'relu' conew 'Activation'
c2=: ((5 10 2 2); 1;'relu';'adam';0.01;0) conew 'Conv2D'
b2=: (0; 1 ;0.0001;5;0.01) conew 'BatchNorm2D'
a2=: 'relu' conew 'Activation'
fl=: 3 conew 'FlattenLayer'
fc=: (5;2;'softmax';'sgd';0.01) conew 'SimpleLayer'
b3=: (0; 1 ;0.0001;2;0.01) conew 'BatchNorm'
a3=: 'softmax' conew 'Activation'

addLayer__pipe c1
addLayer__pipe p1
addLayer__pipe b1
addLayer__pipe a1
addLayer__pipe c2
addLayer__pipe b2
addLayer__pipe a2
addLayer__pipe fl
addLayer__pipe fc
addLayer__pipe b3
addLayer__pipe a3

NB. since this is just a quick exmaple, with no test set, we can just do some pseudo-validation
NB. using the training set. At the very least the two sets A,B should be separated by our nn.
OUTPUT-:"1 1 (=>./)"1 predict__pipe INPUT
 1 1 1 1 1 1 1 1 1 1
NB. seems like it at least separated the training sets correctly, which is all we want for this
NB. example.
```

*** 
### Example

Example shows a convolutional net implemented to solve the MNIST problem.

Problem: classify image data of hand-written numbers from 0 to 9 into the correct classes.
The training set has 60,000 images of hand-written digits, and the test set has a further
10,000 images.

```j
NB. load the image data, and normalize the inputs
rf=: 1!:1 
data=: a.i. toJ dltb , rf < '/path/to/mnist/train/data'
TRAININPUT =: 255 %~ [ 60000 1 28 28 $, 16}. data

data=: a.i. toJ dltb , rf < '/path/to/mnist/test/data'
TESTINPUT =: 255 %~ [ 10000 1 28 28 $, 16}. data

data=: a.i. toJ dltb , rf < '/path/to/mnist/train/labels'
TRAINLABELS =: 60000 10 $ , #: 2^ 8}. data

data=: a.i. toJ dltb , rf < '/path/to/mnist/test/labels'
TESTLABELS =: 10000 10 $ , #: 2^ 8}. data

pipe=: (100;20;'softmax';1; 'l2';0.0001) conew 'NNPipeline'
c1=: ((50 1 4 4);3;'relu';'adam';0.01;0) conew 'Conv2D'
b1 =:  (0; 1 ;1e_4;50;0.001) conew 'BatchNorm2D'
a1 =: 'relu' conew 'Activation'
c2=: ((64 50 5 5);4;'relu';'adam';0.01;0) conew 'Conv2D'
b2 =:  (0; 1 ;1e_4;64;0.001) conew 'BatchNorm2D'
a2 =: 'relu' conew 'Activation'
p1=: 2 conew 'PoolLayer'
fl=: 1 conew 'FlattenLayer'
fc1=: (64;34;'tanh';'adam';0.01) conew 'SimpleLayer'
b3 =:  (0; 1 ;1e_4;34;0.001) conew 'BatchNorm'
a3 =: 'tanh' conew 'Activation'
fc2=: (34;10;'softmax';'adam';0.01) conew 'SimpleLayer'
b4 =:  (0; 1 ;1e_4;10;0.001) conew 'BatchNorm'
a4 =: 'softmax' conew 'Activation'

addLayer__pipe c1
addLayer__pipe b1
addLayer__pipe a1
addLayer__pipe c2
addLayer__pipe b2
addLayer__pipe a2
addLayer__pipe p1
addLayer__pipe fl
addLayer__pipe fc1
addLayer__pipe b3
addLayer__pipe a3
addLayer__pipe fc2
addLayer__pipe b4
addLayer__pipe a4
 
```

After training is run for several (8~10) epochs, using batch size of 100 images per iteration, a 95%+ accuracy rate was attained.
The MNIST dataset is relatively as only one input channel is used and the variation in images per class
is quite limited. It is better to try a more difficult dataset.

### CIFAR-10 Dataset
Dataset can be found here: http://www.cs.utoronto.ca/~kriz/cifar.html

The dataset contains  60000 32x32 colour images in 10 classes, with 6000 images per class.
#### Example loading an image

```j
data=: a.i. toJ dltb , rf < '/path/to/cifar/cifar-10-batches-bin/data_batch_1.bin'
data=: 10000 3073 $, data
img1=: 3 32 32 $ }.{.data
img1=: +/ 65536 256 1 * img1
'rgb' viewmat img1
```
the image shown should, if read correctly show a frog (`{.{.data` gives 6, i.e. label for frogs is 6).

![cifar-frog](/adv/cifar-10-frog.png)


```j
pipe=: (10;10;'softmax';1; 'l2';0.0001) conew 'NNPipeline'
c1=: ((65 1 5 5);3;'relu';'adam';0.001;0;1) conew 'Conv2D' 
c2=: ((80 65 3 3);2;'relu';'adam';0.001;0;1) conew 'Conv2D'
p2=: 2 conew 'PoolLayer'
c3=: ((90 80 2 2);1;'relu';'adam';0.001;0;1) conew 'Conv2D'
fl=: 1 conew 'FlattenLayer'
fc1=: (90;60;'tanh';'adam';0.001;1) conew 'SimpleLayer'
fc2=: (60;10;'softmax';'adam';0.001;1) conew 'SimpleLayer'

   
addLayer__pipe c1 
addLayer__pipe c2
addLayer__pipe p2
addLayer__pipe c3
addLayer__pipe fl
addLayer__pipe fc1
addLayer__pipe fc2

TRAINLABELS fit__pipe TRAININPUT

```

***
## Recurrent Networks

### LSTMs

Long Short Term Memory networks

***
### Example
```j
rotjText=: 'Luke Skywalker has returned to his home planet of Tatooine in an attempt to rescue his friend Han Solo from the clutches of the vile gangster Jabba the Hutt. Little does Luke know that the GALACTIC EMPIRE has secretly begun construction on a new armored space station even more powerful than the first dreaded Death Star. When completed, this ultimate weapon will spell certain doom for the small band of rebels struggling to restore freedom to the galaxy....'

NB. Use only lowercase and remove punctuation
sw=: ';:!?,."''' -.~ tolower rotjText

NB. Use Word2Vec to transform to smaller dimensional space.
NB. Run 2000 epochs, batch size 30. 
'rotjTransformed word2vecs'=: vectorizeText_jLearnText_ sw;5;15;2000;40;0.05;0;0.001
NB. This is our text corpus.
text=: ~.rotjTransformed
NB. we want to seperate into groups of 5 words sequentially.
seq=: 5]\text

NB. Input values as vectors in the lower dimensional vectgor space.
X =: word2vecs {~ text i. seq

NB. Y values are the target words. 
Y=:{:"2 seq="0 _ text

pipe =: (10;20;'softmax';1; 'l2';0.0001) conew 'NNPipeline'
lstm=:  ('tanh';0;0.01;'adam';10;15;100;4;0) conew 'LSTMLayer'
fc =: (100;64;'softmax';'adam';0.01;1) conew 'SimpleLayer'

addLayer__pipe lstm
addLayer__pipe fc

Y fit__pipe X

```

***
### Example

This example uses LSTM to  learn the next values in a numerical sequence.
First we need a verb to create some sequences:

```j
nextValue=: 3 : 0
'a b c d' =: y
q=. -:b + c + d-a
q+6|q
)
```

From the 4 preceding values ina sequence we calculate the nextValue.

We can build the whole sequence (let's say, 500 numbers long):
```j
NB. t will contain the sequence
t=: ''
((3 : ' y[smoutput y')@:(}.,((4 : 'y[t=:t,x,y') nextValue)))^:100[ 5 3 2 4
```

Now we just need to vectorize the *(X,Y)* training data.
```j
n=: ~.t NB. get all unique numbers
s=: 5]\ t NB. create 5-windows
Y=:{:"2 s="0 _ n NB. Y value vectors (length of each vector is 91)
X=: s="0 _ n NB. X value vectors (length of each vector is 91)

NB. create the neural network pipeline.
pipe =: (10;10;'softmax';1; 'l2';0.0001) conew 'NNPipeline'
NB. input vectors are size 91, sequence length 4, hidden size 150.
lstm=:  ('tanh';0;0.01;'adam';10;91;150;4;0) conew 'LSTMLayer'
NB. output size is 91
fc =: (150;91;'softmax';'adam';0.01;1) conew 'SimpleLayer'

addLayer__pipe lstm
addLayer__pipe fc
Y fit__pipe X
NB. ...after training for 10 epochs we can do some testing.
n{~ I.(=>./), >{:predict__pipe ,:10{X
NB. compare this with last value of 10{n

NB. quick check
+/  Y -:"1 1((=>./)"1@:,@:>@:{:@:predict__pipe@:,:)"2[ X
 397
```

***
### Example
Perhaps the above was overly complex. We can make a simple LSTM network.

```j
xxx=: 3 : '(,nextValue) ? 4 $ 20' NB. nextValue is deifned above. Just generates random input.
s=: xxx"0 i.100 NB. 100 samples
n=: ~.,s
Y=:{:"2 s="0 _ n NB. Y value vectors (length of each vector is 91)
X=: s="0 _ n NB. X value vectors (length of each vector is 91)

NB. create the neural network pipeline.
pipe =: (10;10;'softmax';1) conew 'NNPipeline'
NB. 69 is vector size, i.e. # n
NB. input vectors are size 91, sequence length 4, hidden size 150.
lstm=:  ('tanh';0;0.01;'adam';10;69;150;4;0) conew 'LSTMLayer'
NB. output size is 69
fc =: (150;69;'softmax';'adam';0.01;1) conew 'SimpleLayer'

addLayer__pipe lstm
addLayer__pipe fc
Y fit__pipe X
NB. ...after training for 10 epochs we can do some testing.
NB. quick check
+/  Y -:"1 1((=>./)"1@:,@:>@:{:@:predict__pipe@:,:)"2[ X
 100
NB. 100% accuracy, for this small, simple generated data.
```
