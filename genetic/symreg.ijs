Note 0
Copyright (C) 2018 Jonathan Hough. All rights reserved.
)

NB. Symbolic regression

Note 'References'
[0] A Greedy Search Tree Heuristic for Symbolic Regression, Fabricio Olivetti de Franca
link: https://arxiv.org/pdf/1801.01807.pdf

[1] Genetic Programming for Symbolic Regression, Chi Zhang
link: https://pdfs.semanticscholar.org/e5ee/ddd04b8344fd4f39a5836be686886c80df13.pdf

Of interest...
[2] Learning Optimal Control of Synchronization in Networks of Coupled Oscillators using Genetic Programming-based Symbolic Regression, Gout, J. et al.
link: https://arxiv.org/pdf/1612.05276.pdf
)

NB. Symbolic Regressor 
NB. Symbolic Regressor uses primitive operators, placed in sequence, 
NB. which allows J to turn into function by `:6. The placement in sequence
NB. of each operator may be arbitrary, and the Genetic Programming Solver 
NB. is tasked with finding some order that gives an accurate result,
NB. as measured by the cost (fitness) function.
coclass 'SymReg'
coinsert 'GenObj'

NB. primitive functions
'sin cos tan sinh cosh tanh'=: <"0   (1&o.@:])`(2&o.@:])`(3&o.@:])`(5&o.@:])`(6&o.@:])`(7&o.@:])
'arcsin arccos arctan arcsinh arccosh arctanh'=:<"0 (_1&o.@:])`(_2&o.@:])`(_3&o.@:])`(_5&o.@:])`(_6&o.@:])`(_7&o.@:])
'exp log log10'=:<"0 ([:^])`([:^.])`(10&^.@:])
'pow square cube quart quint sext sept'=: <"0  ^`(*:@:])`((^&3)@:])`((^&4)@:])`((^&5)@:])`((^&6)@:])`((^&7)@:])
'sqr root'=: <"0  ([:%:])`%: 
'gamma combos'=:<"0 ([:!])`!
'plus mult sub neg div self left kill'=: <"0 +`*`-`([:-])`%`]`[`[:
'abs mod inc dec floor ciel sign'=:<"0  ([:|])`|`([:>:])`([:<:])`([: <. ])`([: >. ])`([: * ])
'mul2 mul1p5 mul3 mul5 mul7 mul11 mul13 mul10'=: <"0 ([:+:])`(1.5&*@:])`(3&*@:])`(5&*@:])`(7&*@:])`(11&*@:])`(13&*@:])`(10&*@:])
'div2 div3 div5 div7'=: <"0 ([:-:])`(0.3333&*@:])`(0.2&*@:])`(0.142857&*@:])
NB. add constants
'add1r2 add1r3 add2 add3 add4 add5 add6 add7 add8 add9 add10'=:<"0 (0.5&+@:])`(1.5&+@:])`(2&+@:])`(3&+@:])`(4&+@:])`(5&+@:])`(6&+@:])`(7&+@:])`(8&+@:])`(9&+@:])`(10&+@:])

rTerminators=:left
lTerminators=:sin,cos,tan,sinh,cosh,tanh,arcsin,arccos,arctan,arcsinh,arccosh,arctanh
lTerminators=:lTerminators,sqr,gamma,neg,self,abs,inc,dec,floor,ciel,sign
lTerminators=:lTerminators,mul2,mul3,mul5,mul7,mul10,mul11,mul13,div2,div3,div5,div7
lTerminators=:lTerminators,add1r2,add1r3,add2,add3,add4,add5,add6,add7,add8,add9,add10
NB. FOR MULTDIMENSIONAL INPUTS
sumM=: ([: (+/) ])`''
prodM=: ([: (*/) ])`''
subM=: ([: (-/) ])`''

select=: 3 : 0"0
(y&{"1@:])`''
)


setAllowedOperators=: 3 : 0
ops=. tolower y
all=: ''
frq=:''
if. 'b' e. ops do.
  all=: all,sub,plus,div,mult,neg,self,left,kill
  frq=: frq, 2, 2,   2,  2,   2,  2,   2,   4  
  all=: all,mul2,mul3,mul5,mul7,mul10,mul11,mul13
  frq=: frq,1,   1,   1,   1,   1,    1,   1   
  all=: all,div2,div3,div5,div7
  frq=: frq,1   ,1   ,1   ,1
  all=: all,inc,dec,add1r2,add1r3,add2,add3,add4,add5,add6,add7,add8,add9,add10
  frq=: frq,1,  1,  1,     1,     1,   1,   1,   1,   1,   1,   1,   1,   1
end.
if. 't' e. ops do.
  all=: all,sin,cos,tan
  frq=: frq,2,2,2
end.
if. 'T' e. ops do.
  all=: all,arcsin,arccos,arctan
  frq=:frq,1,1,1
end.
if. 'h' e. ops do.
  all=: all,sinh,cosh,tanh 
  frq=: frq,1,1,1
end.
if. 'H' e. ops do.
  all=: all,arcsinh,arccosh,arctanh
  frq=: frq,1,1,1
end.
if. 'g' e. ops do.
  all=: all,gamma
  frq=:frq,1
end.
if. 'p' e. ops do.
  all=: all,pow,square,cube,quart,quint,sext,sept
  frq=: frq,2,2,2,1,1,1,1
end.
if. 'e' e. ops do.
  all=: all,exp
  frq=: frq,2
end.
if. 'l' e. ops do.
  all=: all, log
  frq=: frq,1
end.
if. 'L' e. ops do.
  all=: all, log10 
  frq=: frq,1
end.
if. 'a' e. ops do.
  all=: all,abs
  frq=: frq,2
end.
if. 'r' e. ops do.
  all=: all,sqr,root
  frq=: frq,2,1
end.
if. 'm' e. ops do.
  all=: all,mod
  frq=: frq,1
end.
if. 'i' e. ops do.
  all=: all,floor,ciel,sign
  frq=: frq,1,1,1
end.
if. all-:''do.
  throw. 'There are no allowed operators.'
end.
if. dims > 1 do.
  all=: all,sumM,prodM,subM
  frq=: frq,4,3,4
  NB.all=: all,,select i. dims
  NB.frq=: frq,,
end.
all
)

NB. Creates a Symbolic Regressor instance.
NB. Parameters:
NB. 0: input values.
NB. 1: target values. The fitness (cost) function
NB.    will be measured against these values.
NB. 2: Population size, the number of chromsomes to
NB.    use in the algorithm.
NB. 3: chromosome length. This is the number of operators
NB.    per chromosome.
NB. 4: operators. Allowed operators. THis should be
NB.    a stirng literal containing some of:
NB.    'b': to allow basic operations +-*%
NB.    't': to allow basic trig ops sin,cos,tan
NB.    'T': to allow inverse trig ops asin,acos,atan
NB.    'h': to allow hyp trig ops sinh,cosh,tanh
NB.    'H': to allow inv hyp trig ops asinh,acosh,atanh
NB.    'g': to allow gamma (factorial) op !
NB.    'p': to allow power ops ^2,^3,^4,..
NB.    'e': to allow exponential op (base e) ^
NB.    'l': to allow natural log ops ^.
NB.    'L': to allow base10 log ops 10^.
NB.    'a': to allow absolute op |
NB.    'r': to allow root ops %:
NB.    'm': to allow mod op |
NB.    'i': to allow integer ops, floor, cieling,sign <:>:*
create=: 3 : 0
'input targets popSize cLen operators'=: y
g=. ?@:(cLen&#)"0 0@:(popSize&#)@:# { (i.@:#)
if. 1=#$input do.
  dims=: 1
else.
  dims=: {:$ input
end.
all=: setAllowedOperators operators
chromo=: ;/g all=:frq # all
)

chromosomes=: 3 : 0
chromo
)


populationSize=: 3 : 0
popSize
)

chromosomeLength=: 3 : 0
cLen
)

elongateChromosomes=: 3 : 0
alen=. #all
select=: 3 : '?alen[y'
chromo=: (,select)&.> chromo
)


requestChange=: 3 : 0

g=. ?@:(cLen&#)"0 0@:(popSize&#)@:# { (i.@:#)
newChromo=: ;/g all
hp=. i.>.-:popSize
chromo=: (y{~hp) hp}newChromo
chromo
)

newSequence=: 3 : 0
g=. ?@:(cLen&#)"0 0@:(popSize&#)@:# { (i.@:#)
chromo=: ;/g all
chromo
)

 

NB. Cost function runs on individual chromosomes
NB. of the current solution set. Each chromosome
NB. is transformed into a verb and run on the input
NB. data. The absolute difference between target
NB. and input is returned.
NB. Positive Infinity (_) can be returned in case of
NB. a thrown exception or, if the dimensionality of
NB. the input set is greater than 1 and the output
NB. value is not a single value. If the returned
NB. value is 'complex' then infinity is also returned.
NB. Parameters:
NB. 0: single chromosome, boxed list of integers, where
NB.    each integer is the index of the corresponding
NB.    verb in the gerund list.
NB. returns:
NB.    cost function, in range (0,_). (0 is best)
cost=: 3 : 0"0
f=: all{~ >y
func=: f`:6
diff=. _
try.
  res=. func"1 input
  if. 0 < +/ 1e200 < res do.
    diff=. _ 
  else.
    diff=. | (,targets) -res
    if. 1< #$ diff do.
      diff=. _ 
    elseif.
      'complex' -: datatype res do.
      diff=. _ 
    end.
  end.
catch. 
  diff=. _
catcht. 
  diff=. _
catchd. 
  diff=. _
  
end.
if. 1 e. ~:~ diff do. diff=. _ end. NB. in case of _.

(+/ % #) diff
)


destroy=: codestroy

Note 'todo'
 (I.@:(6&=) {. ])&:>best NB. (here 6 is the index in all that [`'' has)
)