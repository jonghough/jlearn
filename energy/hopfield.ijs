Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

NB. Implementation of a Hopfield Artificial Neural Network.
NB. Hopfield ANNs are defined by...

Note 'Example'
Create a Hopfield network to recognize the folloiwing patterns:
pattern1:
1 _1 _1 1
1 _1 _1 1
1 _1 _1 1
1 _1 _1 1

pattern2:
 1  1  1  1
_1 _1 _1 _1
_1 _1 _1 _1
 1  1  1  1

pattern3:
_1  1  1 _1
 1 _1 _1  1
 1 _1 _1  1
_1  1  1 _1

p1=: 4 4 $ 1 _1 _1 1
p2=: |: p1
p3=: 4 4 $ _1 1 1 _1 1 _1 _1 1 1 _1 _1 1 _1 1 1 _1

Create the hopfield network instance

H=: (p1;p2;p3) conew 'Hopfield'

Create a test pattern, almost pattern1, but with some differences:
test=: 4 4 $ 1 _1 _1 _1 1 _1 _1 1 1 _1 _1 1 1 1 _1 1

predict__H test
)

coclass 'Hopfield'
randm=: ?@:(=@i.)			NB. random matrix
inverseIdentity=: 2&|@:>:@:(=@i.)	NB. inverted identity matrix
dot=: +/ . *			NB. dot product
make2d=: ,&1@:$ $ ]		NB. make 1D array 2D
NB.pairs=: (#~ </"1)@(#: i.@:(*/))	NB. collect pairs of
combinations=: > @ , @ { @ (i.&.>"_)

NB. Instantiate a Hopfield Network with the
NB. given training set. The traiing set will be
NB. used to predict test data.
create=: 3 :0
dimensions=: {:$,>{.y
 
S=: dimensions $ 1

NB. edges=: (inverseIdentity dimensions) * (dimensions,dimensions)$ ((+/&:>) % #) (*/"1@:(P&{"_ 1)@:,)&.> y
edges =: (inverseIdentity dimensions) * (dimensions,dimensions)$ ,((+/&:>) % #) (*"0 _/~@:,)&.> y
)

predict=: 3 : 0
shape=. $ y
d=. make2d ,y
dc=. d
maxIteration=. 100
c=. 0
while. c < maxIteration do.
  c=. c+1
  S=: output edges dot d
  if. S -: d do. break. end.
  d = S
end.
shape $ ,S
)

output=: 3 :0 "0
1:`_1:@.(0&>) y
)

energy=: 3 :0
y2d=. make2d ,y
_0.5 * (|: y2d) dot edges dot y2d

)


destroy=: codestroy

