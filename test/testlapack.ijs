Note 0
Copyright (C) 2022 Jonathan Hough. All rights reserved.
)

require jpath '~Projects/jlearn/utils/lapackutils.ijs'

coclass 'TestLapack'
coinsert 'TestBase'

create=: 3 : 0
''
)


testSVD1=: 3 : 0 
D=. 3 3 $ 1 2 0 2 3 _1 0 _1 5
'evecs evals'=. svd_jUtilsLapack_ D
L=. | D (+/ .*) |: evecs
R=.   |( |:evecs)*"1 (evals) 
epsilon=. 1e_4
E=.,epsilon$~$R 
(~.@:(E&>)) assertTrue (,L - R)
) 

testSVD2=: 3 : 0 
NB. not symmetric
D=. 3 3 $ 1 2 0 2 3 _1 1 1 1 
svd_jUtilsLapack_ assertThrow D
)  

run=: 3 : 0
testSVD1 testWrapper 'Test SVD 1'
testSVD2 testWrapper 'Test SVD throws error for non-symmetric matrix.'   
''
)

destroy=: 3 : 0  
codestroy ''
)

tk=: 1 conew 'TestLapack'
run__tk 0