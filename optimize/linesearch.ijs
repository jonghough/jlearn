Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

cocurrent 'jLearnOpt'


lineSearch=: 3 : 0
'fg fpg xk pk gfk c1 c2 amax maxIter'=. y
func=: fg`:6
fprime=: fpg`:6
am1=. a0=.  1e_5
ai=. amax
it=. 0
alpha=. ai
dot=: +/ . *
while. it < maxIter do.
  it=. it+1
  
  fk=. func xk + ai *pk
  
  if.(fk > (func xk) + c1*ai*(+/pk * fprime xk)) +. ((it > 1) *. fk >: func xk + am1 *pk) do.
    alpha=. zoom fg;fpg;xk;pk;am1;ai;c1;c2;10
    break.
  end.
  gai=. +/ pk * (fprime xk + ai * pk)
  if. (| gai) <: -c2 * (+/ pk * fprime xk) do.
    alpha=. ai
    break.
  end.
  if. gai >: 0 do.
    alpha=. zoom fg;fpg;xk;pk;ai;am1;c1;c2;10
    break.
  end.
  am1=. ai
  if. amax <: +: ai do.
    ai=. amax
  else. ai=. +: ai
  end.
end. 
alpha
)


qinterpolate=: 3 : 0
'a0 a1 fa0 fa1 fga0 fga1'=: y
try.
d=.a1-a0
''$,a0-((fa1 - fa0 + fga0 * d )%~ -: fga0 * *: d)
catch.
return. _
end.
)


zoom=: 3 : 0
'fg fpg xk pk al ah c1 c2 maxIter'=. y
func=. fg `:6
fprime=. fpg `:6
alpha=. ah
its=. 0
while. 1 do.
  dif=. ah - al
  if. dif < 0 do.
    t=. al
    al=. ah
    ah=. t
    dif=. ah - al
  end.
  its=. >:its
  fal=. func xk + al *pk
  fah=. func xk + ah *pk
  fgal=. +/ pk * fprime xk + al *pk
  fgah=. +/ pk *fprime xk + ah * pk
  aj=: qinterpolate (al);(ah); fal; fah;fgal; fgah

   if. (aj > ah - 0.1 * dif)  +. aj < al + 0.1 * dif do.
    aj =: -: ah + al
   end.
  alpha=. aj
NB.if. (ah - al) < 1e_3 do. break. end.
  fj=. (func xk + aj *pk) 
  if. fj > (func xk) + c1*aj* (+/ pk * fprime xk) do.
    ah=. aj
  elseif. fj >: (func xk + al *pk) do.
    ah=. aj
  elseif. 1 do.
    
    fpj=: +/ pk * fprime xk + aj * pk 
    if. (| fpj) <: -c2 * (+/ pk * fprime xk) do.
      
      alpha=. aj
      break.
    end.
    if. (fpj * (ah - al)) >: 0 do.
      
      ah=. al
    end.
    al=. aj
  end.
  
  if. its >: maxIter do.
    NB. smoutput 'zoom function: max iterations over-ran.'
    break.
  end.
end.
alpha
)