NB. loading the cifar 10 data


NB. filepath to cifar10 dataset files (6 files ending in .bin)
datapath='D:/'
NB. read file
rf=:  1 !: 1

data=: a.i.  , rf < datapath, '/data_batch_1.bin'

data=: 10000 3073 $, data
TRAINLABELS1=: {."1 data
TRAINDATA1=: 10000 3 32 32 $, }."1 data

data=: a.i.  , rf < datapath, '/data_batch_2.bin'
data=: 10000 3073 $, data
TRAINLABELS2=: {."1 data
TRAINDATA2=: 10000 3 32 32 $, }."1 data

data=: a.i.  , rf < datapath, '/data_batch_3.bin'
data=: 10000 3073 $, data
TRAINLABELS3=: {."1 data
TRAINDATA3=: 10000 3 32 32 $, }."1 data

data=: a.i.  , rf < datapath, '/data_batch_4.bin'
data=: 10000 3073 $, data
TRAINLABELS4=: {."1 data
TRAINDATA4=: 10000 3 32 32 $, }."1 data

data=: a.i.  , rf < datapath, '/data_batch_5.bin'
data=: 10000 3073 $, data
TRAINLABELS5=: {."1 data
TRAINDATA5=: 10000 3 32 32 $, }."1 data

NB. the test data is the 6th batch.
data=: a.i.  , rf < datapath, '/data_batch_6.bin'
data=: 10000 3073 $, data
TESTLABELS=: #: 2^{."1 data
TESTDATA=: 255 %~ 10000 3 32 32 $, }."1 data


NB. accumulate and transform the train labels (one hot encode)
TRAINLABELS=: TRAINLABELS1, TRAINLABELS2,TRAINLABELS3, TRAINLABELS4, TRAINLABELS5
TRAINLABELS=: |: ,: TRAINLABELS
TRAINLABELS=: ,/ #: 2^ TRAINLABELS

NB. accumulate and transform the training data , shape of the data will be
NB. 50000 x 3 x 32 x 32
TRAINDATA=: (,TRAINDATA1), (,TRAINDATA2),(,TRAINDATA3),(,TRAINDATA4),(,TRAINDATA5)
TRAINDATA1=: TRAINDATA2=: TRAINDATA3=: TRAINDATA4=: TRAINDATA5=: ''
TRAINDATA =: 255%~ 50000 3 32 32 $ TRAINDATA

NB. select random validation set as a subset of the test set.
V=: 500 ? 10000
VD=: V{TESTDATA
VL=: V{TESTLABELS
f=: 3 : '+/ ((y + i. 100){TESTLABELS) -:"1 1 (=>./)"1 >{:predict__pipe (y+i.100){TESTDATA'
g=: 3 : '+/ ((y + i. 100){VL) -:"1 1 (=>./)"1 >{:predict__pipe (y+i.100){VD'
h=: 3 : '+/ ((y + i. 100){TRAINLABELS) -:"1 1 (=>./)"1 >{:predict__pipe (y+i.100){TRAINDATA'

load 'plot'
