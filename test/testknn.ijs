
require jpath '~Projects/jlearn/knn/knn.ijs'
coclass 'TestKNN'
coinsert 'TestBase'
create=: 3 : 0
''
)


test1=: 3 : 0
D=:  99 3 $ , (=@i.) 3
R=: D
knn=: (D;R;7;D) conew 'KNN'
predict__knn '' 
(33 33 33&-:@:(#/.~)) assertTrue maxClasses__knn
)



run=: 3 : 0
test1 testWrapper 'Knn test 1' 
''
)


destroy=: 3 : 0 
if. -. knn-: '' do. destroy__knn '' end.
codestroy ''
)

tk=: '' conew 'TestKNN'
run__tk 0