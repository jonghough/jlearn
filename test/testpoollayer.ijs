NB. Test Pool Layer.


coclass 'TestPoolLayer'
coinsert 'TestBase'


create=: 3 : 0
''
)


test1=: 3 : 0
p1 =: 2 conew 'PoolLayer'
a=: 3 3 8 8 $ 1 NB. batchsize x depth x width x height
out=: forward__p1 a
3 3 4 4&= assertTrue ($out)
3 3 8 8&= assertTrue ($backward__p1 out)
destroy__p1 ''
)

test2=: 3 : 0
p1 =: 5 conew 'PoolLayer'
a=: 3 3 20 20 $ 1 NB. batchsize x depth x width x height
out=: forward__p1 a
3 3 4 4&= assertTrue ($out)
3 3 20 20&= assertTrue ($backward__p1 out)
destroy__p1 ''
)


test3=: 3 : 0
p1 =: 8 conew 'PoolLayer'
a=: 2 20 16 16 $ 1 NB. batchsize x depth x width x height
out=: forward__p1 a
2 20 2 2&= assertTrue ($out)
2 20 16 16&= assertTrue ($backward__p1 out)
destroy__p1 ''
)


run=: 3 : 0
test1 testWrapper 'PoolLayer Test 1' 
test2 testWrapper 'PoolLayer Test 2' 
test3 testWrapper 'PoolLayer Test 3' 
''
)


destroy=: 3 : 0  
codestroy ''
)

tpool=: '' conew 'TestPoolLayer'
run__tpool 0