
load 'math/calculus'
require jpath '~Projects/jlearn/optimize/linesearch.ijs'
require jpath '~Projects/jlearn/optimize/conjugategradient.ijs'
require jpath '~Projects/jlearn/optimize/neldermead.ijs'
require jpath '~Projects/jlearn/optimize/lbfgs.ijs'

coclass 'TestOptimize'
coinsert 'TestBase'
create=: 3 : 0
''
)


NB. ====================TEST BFGS====================
test1=: 3 : 0 NB. f = x^2
f=: *:
fp=: +:
minima=: minBFGS_jLearnOpt_ (f f.`'');(fp f.`'');(4);1e4;1e_4;_0.1
( 1e_3&>@:|) assertTrue minima
)

test2=: 3 : 0 NB. f = (x+1)^2
f=: *:@:>:
fp=: (f f.) deriv_jcalculus_ 1
minima=: minBFGS_jLearnOpt_ (f f.`'');(fp f.`'');(4);1e4;1e_5;0.1 
(1e_3&>@:>:) assertTrue minima
)

test3=: 3 : 0 NB. f = x^2  +  y^3
f=: *:@:{. + (3&(^~)@:{:)
fp=: (+:@:{. , (2&(^~)@:(3&*)@:{:))    
minima=: +/*: minBFGS_jLearnOpt_ (f f.`'');(fp f.`'');(0 0);1e4;1e_5;0.1
(1e_3&>) assertTrue minima
)

NB. should throw an exception. This has no gradient minimum.
test4=: 3 : 0 NB. f = e^(x-y)  +  x  - (y-1)^4
f=:^@:-/ + {. - 4&(^~)@:<:@:{:
fp=: >:@:^@:-/ , 4&*@:(3&(^~))@:{: + -@:^@:-/  
(minBFGS_BFGS_ assertThrow (f f.`'');(fp f.`'');(4 3);1e5;1e_4;0.0001)
)

NB. ====================TEST L-BFGS====================
NB. ======= Essentially the same tests as BFGS ========
test5=: 3 : 0 NB. f = x^2
f=: *:
fp=: +:
minima=: minLBFGS_jLearnOpt_ (f f.`'');(fp f.`'');(3.5);1e4;1e_4
( 1e_3&>@:|) assertTrue minima
)

test6=: 3 : 0 NB. f = (x+1)^2
f=: *:@:>:
fp=: (f f.) deriv_jcalculus_ 1
minima=: minLBFGS_jLearnOpt_ (f f.`'');(fp f.`'');(4);1e4;1e_4
(1e_3&>@:>:) assertTrue minima
)

test7=: 3 : 0 NB. f = x^2  +  y^3
f=: *:@:{. + ((^&3)@:{:)
fp=: (+:@:{. , ((3&*)@:*:@:{:))    
minima=: +/*: minLBFGS_jLearnOpt_ (f f.`'');(fp f.`'');(4 3);1e5;1e_4
(1e_3&>) assertTrue minima
)

NB. should throw an exception. This has no gradient minimum.
test8=: 3 : 0 NB. f = e^(x-y)  +  x  - (y-1)^4
f=:^@:-/ + {. - 4&(^~)@:<:@:{:
fp=: >:@:^@:-/ , 4&*@:(3&(^~))@:{: + -@:^@:-/  
(minLBFGS_BFGS_ assertThrow (f f.`'');(fp f.`'');(4 3);1e5;1e_4)
)

 



NB. ====================TEST CONJ_GRAD====================
NB. ======= Essentially the same tests as BFGS ========
test9=: 3 : 0 NB. f = x^2
f=: *:
fp=: +:
minima=: minCG_jLearnOpt_ (f f.`'');(fp f.`'');(4);1e4;1e_5;'fr'
( 1e_3&>@:|) assertTrue minima
)

test10=: 3 : 0 NB. f = (x+1)^2
f=: *:@:>:
fp=: (f f.) deriv_jcalculus_ 1
minima=: minCG_jLearnOpt_ (f f.`'');(fp f.`'');(4);1e4;1e_5;'fr' 
(1e_3&>@:>:) assertTrue minima
)


funcCG1=: 3 : 0
M=: 4 4 $ 10 _1 2 0.5,   _1 6 _2 2,   2 _2 7 0,   0.5 2 0 3
b=: 1 4 $ 1 5 0.25 0
dot=. +/ . *
y=. 4 1 $, y
6 + , (b dot y) + (|:y) dot M dot y
)


funcpCG1=: 3 : 0
M=: 4 4 $ 10 _1 2 0.5,   _1 6 _2 2,   2 _2 7 0,   0.5 2 0 3
dot=. +/ . *
y=. 4 1 $, y
b=: 4 1 $ 1 5 0.25 0
,b-~  M dot y
)

test11=: 3 : 0  
minima=:  minCG_jLearnOpt_ (funcCG1 f.`'');(funcpCG1 f.`'');(0.1 0.5 0.1 1.5);200;1e_3;'fr'
(*/@:(1e_3&>)) assertTrue (| minima - 0.203 1.276 0.342 _0.884)
)

NB. should throw an exception. This has no gradient minimum.
test12=: 3 : 0 NB. f = e^(x-y)  +  x  - (y-1)^4
f=:^@:-/ + {. - 4&(^~)@:<:@:{:
fp=: >:@:^@:-/ , 4&*@:(3&(^~))@:{: + -@:^@:-/  
(minCG_jLearnOpt_ assertThrow (f f.`'');(fp f.`'');(4 3);1e3;1e_3;'fr')
)





func1=: 3 : 0
'a b c'=. y 
(2 o. a)  + (- 1 o. (a+b)) + *: c
)

funcp1=: 3 : 0
'a b c'=. y
( - (1 o. a) + (2 o. (a+b))) , ( -(2 o.(a+b))) ,(+:c)
)


test13=: 3 : 0   
minima=:   (minLBFGS_jLearnOpt_ (func1 f.`'');(funcp1 f.`'');(0 0 0);1e4;1e_3)   
(*/@:(1e_3&>)@:funcp1) assertTrue minima
)





func2=: 3 : 0
y=. 3 1 $ ,y
A=. 3 3 $ 2 _1 0 _1 2 _1 0 _1 2
2 + ,(|: y) (+/ . *) A (+/ . *) y
)

funcp2=: 3 : 0
y=. 3 1 $ ,y
A=. 3 3 $ 2 _1 0 _1 2 _1 0 _1 2
,A (+/ . *) y
)

test14=: 3 : 0     
minima=:  minCG_jLearnOpt_ (func2 f.`'');(funcp2 f.`'');(0.1 2 0.5);1e4;1e_4;'fr'
(1e_3&>) assertTrue  (+/*: minima)
)

run=: 3 : 0
 

test1 testWrapper 1 
test2 testWrapper 2 
test3 testWrapper 3 
test4 testWrapper 4 
test5 testWrapper 5 
test6 testWrapper 6 
test7 testWrapper 7 
test8 testWrapper 8 
test9 testWrapper 9 
test10 testWrapper 10 
test11 testWrapper 11
test12 testWrapper 12 
test13 testWrapper 13 


'end'
)


destroy=: 3 : 0
codestroy ''
)


    to=: '' conew 'TestOptimize'
   run__to ''