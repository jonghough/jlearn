Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


Note 1
This is an implementation of the Nedler-Mead method for 
unconstrained function optimization. 
Example usage of dyadic verb minimizeNelderMead:
1-dimensional example (function from R->R), where the function
to minimize is given by
func = 5x^2 -7x + 2
Define function:
func=:2&+@:(_7&* + 5&*@:*:)
Input samples given by samples
(func f.) `'' minNelderMead_jLearnOpt_ samples
will minimize this function, using the sample data.
)


cocurrent 'jLearnOpt' 

alpha =: 1
gamma=: 2
rho=: 0.5
sigma =: 0.5

order=: 4 : 0
func=. x `:6
data=. y

vals=. func data
od=. data /: vals NB. ordered data
ov=. /:~ vals NB. ordered values

od;ov
)

reflect=: 4 : 0
func=. x `:6
data=. y
centroid=. (+/ % #) data
last=. {: data 
ref=. centroid + alpha * (centroid - last)
ref
)


expand=: 4 : 0
func=. x `:6
'data ref'=. y 
centroid=. (+/ % #) data
ex=. centroid + gamma * (ref - centroid)
ex
)


contract=: 4 : 0
func=. x `:6
data=. y 
centroid=. (+/ % #) data
con=. centroid + rho * (({: data) - centroid)
con
)


minNelderMeadX=: 3 : 0
'funcWrapper x0 maxIter tol beta'=: y
func=. 3 : ' func__funcWrapper y'"1 
d=. 20 3 $, 10 * +: 0.5-~?  (20 3) $ 0
smoutput $d
data=.20 1 $, func"1 d
 smoutput $data
((func f.)`'') minNelderMead d
)

minNelderMead=: 4 : 0 "0 _
func=: (x `:6) f.
data=. y
iterations =. 50
ctr=. 0
while. ctr < iterations do.
 ctr=. ctr+1
  o=. x order data
  od=. >{.o NB. ordered data
  ov=. >{:o NB. ordered values 
  drop=. }: od
  ref=: (func `'') reflect drop
NB. REFLECTION 
  if. (( (x `:6) {. drop) <:  (x `:6) ref) *. (( (x `:6) ref) <  (x `:6) {: drop) do.
    nextData=. ( drop), ref NB. append ref to the list
    data=. nextData
    continue.
    
  end.
NB. EXPANSION  
  if. (func ref) < func {. drop do.
    ex=: x expand data;ref
    if. (func ex) < func ref do.
      drop=. }: data
      nextData=. ( drop), ex NB. append ex to the list
      data=. nextData
      continue.
    else.
      drop=. }: data
      nextData=. ( drop), ref NB. append ref to the list  
      data=. nextData
	continue.
    end.
  end.
NB. CONTRACTION 
con =. x contract data
if. (func con) < func {: data do.
 drop=. }: data
      nextData=. ( drop), ref NB. append ref to the list  
      data=. nextData
	continue.
end.
first=. {. data
d=. first
for_i. 1}.i.#data do.
d=. d, (first + sigma *((i{data) - first)) 
end.
data =. d
end.
)

