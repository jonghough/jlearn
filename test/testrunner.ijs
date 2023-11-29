
require jpath '~Projects/jlearn/test/testbase.ijs'
require jpath '~Projects/jlearn/test/testgmm.ijs'
require jpath '~Projects/jlearn/test/testoptimize.ijs'
require jpath '~Projects/jlearn/test/testknn.ijs'
require jpath '~Projects/jlearn/test/testnnopt.ijs'
require jpath '~Projects/jlearn/test/testlapack.ijs'
require jpath '~Projects/jlearn/test/testpca.ijs'
require jpath '~Projects/jlearn/test/testserialize.ijs'
require jpath '~Projects/jlearn/test/testpoollayer.ijs'
cocurrent 'TestRunner'

runAll=: 3 : 0
tests=. 'TestOptimize';'TestGMM';'TestKNN';'TestNNOpt';'TestLapack';'TestPCA'; 'TestSerialize';'TestPoolLayer'
c=. # tests
p=. 0
for_i. i. c do. 
  t=: '' conew >i{tests
  run__t '' 
  if. pass__t -: testCount__t do.
    p=. p+1
  end.
  
  smoutput (":>i{tests), '::  # tests: ', (":testCount__t), ', # passed: ', (":pass__t)
  smoutput '------------------------------------------------------------------'
destroy__t ''
end.
smoutput p
pc=. >.100 * p % c
smoutput 'Tests passed: ',(":pc),'%.'
'finished tests'
)


runAll_TestRunner_ ''