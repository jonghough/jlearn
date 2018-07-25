
require jpath '~Projects/jlearn/test/testbase.ijs'
require jpath '~Projects/jlearn/test/testgmm.ijs'
require jpath '~Projects/jlearn/test/testoptimize.ijs'
require jpath '~Projects/jlearn/test/testknn.ijs'
require jpath '~Projects/jlearn/test/testnnopt.ijs'
cocurrent 'TestRunner'

runAll=: 3 : 0
t=: '' conew 'TestOptimize'
run__t ''
destroy__t ''

t=: '' conew 'TestGMM'
run__t ''
destroy__t ''

t=: '' conew 'TestKNN'
run__t ''
destroy__t ''

t=: '' conew 'TestNNOpt'
run__t ''
destroy__t ''

t=: '' conew 'TestPoolLayer'
run__t ''
destroy__t ''

'finished tests'
)