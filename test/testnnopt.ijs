require jpath '~Projects/jlearn/mlp/mlpopt.ijs'

coclass 'TestNNOpt'
coinsert 'TestBase'


create=: 3 : 0
''
)


testAdam1=: 3 : 0 
A =. 10 10 $ 1
Ag =. 10 10 $ 0.5

adam =. (<A) conew 'AdamSolver'

res=.(<A) calcGrad__adam <Ag  
t1=.(10 10&-:) assertTrue  ($>res) 
diff=. | 0.980392 - (~.,>res)
t2=.(1e_4&>) assertTrue diff
smoutput t1
t1 * t2
)

testSGD1=: 3 : 0
A =. 10 10 $ 1
Ag =. 10 10 $ 0.5

sgd =. 0.9 conew 'SGDSolver'

res=.(<A) calcGrad__sgd <Ag  
(10 10&=) assertTrue  ($>res)
(0.55&=) assertTrue (~.,>res)
)

testSGD2=: 3 : 0
A =. 10 10 $ 1
B=. 6 6 $ 1.5
Ag =. 10 10 $ 0.5
Bg =. 6 6 $ 0.1
sgd =. 0.9 conew 'SGDSolver'

res=.(A;B) calcGrad__sgd Ag;Bg  
(((10 10);6 6)&-:) assertTrue  ($&.> res) 
)


testSGDM1=: 3 : 0
A =. 10 10 $ 1
B=. 6 6 $ 1.5
Ag =. 10 10 $ 0.5
Bg =. 6 6 $ 0.1
sgdm =. (0.001;0.09) conew 'SGDMSolver'

res=.(A;B) calcGrad__sgdm Ag;Bg  
(((10 10);6 6)&-:) assertTrue  ($&.> res) 
)

testAdaGrad1=: 3 : 0
A =. 10 10 $ 1
B=. 6 6 $ 1.5
Ag =. 10 10 $ 0.5
Bg =. 6 6 $ 0.1
ags =.  (A;B) conew 'AdaGradSolver'

res=.(A;B) calcGrad__ags Ag;Bg  
(((10 10);6 6)&-:) assertTrue  ($&.> res) 
)


run=: 3 : 0
testAdam1 testWrapper 'Adam Optimizer test 1' 
testSGD1 testWrapper 'SGD Optimizer test 1' 
testSGD2 testWrapper 'SGD Optimizer test 2' 
testSGDM1 testWrapper 'SGDM Optimizer test 1' 
testAdaGrad1 testWrapper 'AdaGrad Optimizer test 1' 
''
)

destroy=: 3 : 0  
codestroy ''
)

tk=: 1 conew 'TestNNOpt'
run__tk 0