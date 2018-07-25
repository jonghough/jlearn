NB. utility verbs


sequenceFunc=: 3 : 0
'a b c d' =: y
a +(*:b-1) + (3|c) -+:d
)

sf=: 3 : 0
'a b c d' =: y
a=: 10 * a
b=: a | 7 * b
c=: 50 | *: c
d =: +: d
q=. b + c + d-a
100 | q
)



rs=: 4 : 0
'all IN'=:y
c=. 0
outs=. ''
while. c < x do.
c=.c+1
 OUT=.  ,@:>@: {:@:predict__pipe ,: IN
 
 outs=. outs, out=. I.(=>./)OUT
IN=. all,~}.IN
 
end.
outs
)

runSeq=: 4 : 0
'w2v shape IN'=: y
c=. 0
outs=. ''
while. c < x do.
c=.c+1
 OUT=.  (,@:>@: {:@:predict__pipe@:((1 4 15&$)@:,)) IN
 
 outs=. outs, out=. I.(=>./)OUT
IN=. (out{w2v),~}.IN
 
end.
outs
)

runSeq2=: 4 : 0
IN=: y
c=: 0
outs=: ''
while. c < x do.
c=:c+1
 O=:  (,@:>@: {:@:predict__pipe@:((1 4 52&$)@:,)) IN
 
 outs=: outs, out=. I.(=>./)O
IN=: (out{X),~}.IN
 
end.
outs
)


runSeq3=: 4 : 0
'w2v shape IN'=: y
c=. 0
outs=. ''
while. c < x do.
c=.c+1
 OUT=.  (,@:>@: {:@:predict__pipe@:((1 4 25&$)@:,)) IN
 
 outs=. outs, out=. I.(=>./)OUT
IN=. (out{w2v),~}.IN
end.
outs
)