

coclass 'TestBase'

testCount=:0
pass=:0
NB. Assert left-hand verb evaluates the right-hand
NB. noun's first argument to match the right-hand
NB. noun's second argument.
NB. Example:
NB. >  *: assertEquals (2;4)
assertEquals=: 2 : '((u&.>)0{n) -: (1{n)'


NB. Asserts that the left-hand verb evaluating the
NB. right-hand noun returns 1 (true).
NB. Example:
NB. >  (1&<@:+:) assertTrue 2
NB.
NB. Following example fails:
NB. >  (1&<@:+:) assertTrue _2
assertTrue=: 2 : '1-:"(0 0) u n'


NB. Asserts that the left-hand verb evaluating the
NB. right-hand noun returns 0 (false).
NB. Example:
NB. >  (1&<@:+:) assertFalse _2
NB.
NB. Following example fails:
NB. >  (1&<@:+:) assertFalse 2
assertFalse=: 2 : '0-:"(0 0) u n'


NB. Asserts that the left-hand verb, will throw an
NB. exception when evaluating the right-hand noun.
NB. Returns 1 if an exception is thrown and false otherwise.
NB. Example:
NB. >  M =: 2 2 $ 1        NB. a singular matrix
NB. >  %. assertThrow M    NB. cannot invert
assertThrow=: 1 : 0
a=. 0
try.
  k=. u y
catch.
  a=. 1
catcht.
  a=. 1
catchd.
  a=. 1
end.
a=1
)

assertNoThrow=: 1 : 0
-. u assertThrow y
)


NB. Wraps the test verbs. Runs the given test, which should be
NB. an argument-less verb. The right-hand noun should be an
NB. identifier (e.g. a number, or name) to identify the test,
NB. in case it fails.
NB. Example:
NB. >  myTest testWrapper 'Matrix inverse test'
testWrapper=: 1 : 0
testCount=:,testCount+1
res=. u ''
smoutput res
if. -. res do.
  smoutput 'Failed test ', ":y
else.
  smoutput 'Test success ', ":y
end.
pass=:pass+,res
res
)



create=: destroy=: codestroy

run=: 3 : 0
1
)
 