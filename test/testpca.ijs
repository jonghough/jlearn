Note 0
Copyright (C) 2022 Jonathan Hough. All rights reserved.
)

require jpath '~Projects/jlearn/dr/pca.ijs'
require jpath '~Projects/jlearn/datasets/iris.csv'

coclass 'TestPCA'
coinsert 'TestBase'

create=: 3 : 0
''
)


testPCA1=: 3 : 0 
D=. 3 3 $ 1 2 0 2 3 _1 0 _1 5
pca =. '' conew 'PCASolver'
X=. transform__pca D;1;3
Y=. inverse__pca X
epsilon=. 1e_4 
1&=@:~.@:(epsilon&>)@:,@:(Y&-) assertTrue  D
) 


testPCA2=: 3 : 0 
'T Y'=: 4 readCSV_jLearnUtil_ jpath '~Projects/jlearn/datasets/iris.csv'

pca =. '' conew 'PCASolver'
X=. transform__pca T;1;4
Y=. inverse__pca X
epsilon=. 1e_4 
1&=@:~.@:(epsilon&>)@:,@:(Y&-) assertTrue  T
)

testPCA3=: 3 : 0 
D=. 10 4 $ 12 2 0 2 5 _1 2 _7 5
pca =. '' conew 'PCASolver' 
X=. transform__pca D;1;3 
(3&=@:({:@:$)) assertTrue  X
) 

 
run=: 3 : 0
testPCA1 testWrapper 'Test inverse of PCA of Matrix is equal to original Matrix.'    
testPCA2 testWrapper 'Test inverse of PCA of Matrix for iris dataset is equal to original Matrix.'    
testPCA3 testWrapper 'Test 3 principle components are returned.'

''
)

 

destroy=: 3 : 0  
codestroy ''
)

tk=: 1 conew 'TestPCA'
run__tk 0