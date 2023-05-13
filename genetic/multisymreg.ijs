


coclass 'MultiSymReg'



create=: 3 : 0
unifier=: (+/@:(*,+,-,*:)/)`(+/@:^)`(+/)`(-/)`(*/)`(+/@:(+,-)/)`(+/@:({. -"0 _ ]))`+/@:({: -"0 _ ])''
symFinal=: (X;Y;150;8;'belLtTHhargp') conew 'SymReg'
sym0=: (X;Y;150;8;'belLtTHhargp') conew 'SymReg'
sym1=: (X;Y;150;8;'belLtTHhargp') conew 'SymReg'
sym2=: (X;Y;150;8;'belLtTHhargp') conew 'SymReg'

solver0=: (sym0;0.2;20;10;0.001;0;1) conew 'GASolver'
solver1=: (sym1;0.2;20;10;0.001;0;1) conew 'GASolver'
solver2=: (sym2;0.2;20;10;0.001;0;1) conew 'GASolver'
solverF=: (symFinal;0.2;20;10;0.001;0;1) conew 'GASolver'
)



run=: 3 : 0

ctr=: 0
while. ctr < 10 do.
  ctr=. Ctr+1
  for_i. # all__sym0 do.
    c0=: >i{all__sym0
    func0=: c0`:6
    for_j. # all__sym1 do.
      c1=: >j{all__sym1
      func1=: c1`:6
      for_k. # all__sym2 do.
        c2=: >k{all__sym2
        func2=: c2`:6

      end.
    end.
  end.
  
end.

)