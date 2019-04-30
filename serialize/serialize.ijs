Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)


NB. Object serialization


NB. Serializer will serialize object, including dependent
NB. objects and cross-references, into a single string,
NB. which can be saved, or passed.
coclass 'Serializer'
strsplit=: #@[ }.each [ (E. <;.1 ]) ,


NB. Create a 'Serializer' instance. Serializer is
NB. used to serialize classes.
NB. example, using a mlp classifier:
NB. > C=. ((4 8 8 5 3);'tanh';'softmax'; 0.1; 0.2; 100;'L2'; 'SGD';5) conew 'MLPClassifier'
NB. > mySerializer =:  '' conew 'Serializer'
NB. > result=: serialize__mySerializer C
NB.
create=: 3 : 0
Q=: ''    NB. serialized object queue
Qr=: ''   NB. to-be-serialized object queue
R=: ''    NB. already-read object list.
''
)

NB. serializes an object, including all other
NB. objects in its reference graph.
NB. Parameters:
NB. y: initial object to serialize.
NB. returns:
NB.   string representing serialized object(s).
serialize=: 3 : 0
if. isPrimitive y do.
,hfd a.i. (3!:1)"_ y return.
end.
if. 1=# copath y do.
  throw. 'Error serializing non-object'
end.
Q=: ''
R=: ''
Qr=: <'root_obj';y
while. 0<#Qr do.
  s=. (>@:{. sObj {:) >{. Qr
  s=. s,'end',LF
  Qr=: }.Qr
  Q=: s,Q
end.
Q
)


NB. Serialize a single J object.
sObj=: 4 : 0
TYPE=. ":,>{.copath y
s=. 'object: ',x,' ',TYPE,LF
l=: }.nl__y ''
for_i. i.#l do.
  name=. >i{l
  isnamet=. (":".name,'__y') -: TYPE
  if.isnamet +. isPrimitive ".(5!:5<(name,'__y')) do.
    s=. s,name,'=:', (": ". ',hfd a.i. (3!:1)"_ ',name,'__y'),LF
  else.
    t=. nc <":(,name),'__y'
    if. t = 0 do.
      len=. # ".(,name),'__y'
      for_j. i.len do.
        obj=. j{ ".(,name),'__y'
        type=. ": ,>{.copath obj 
        hashnm=: ": >obj  
        s=. s,name,'=:o',(":j),' ',(hashnm),' ',type,LF
        if. -. R e.~ obj do.
          Qr=: Qr,<(hashnm); (,obj)
          R=: R, obj
        end.
      end.
    else.
      s=. s,name,'=:n ',(":5!:5<name,'__y'),LF
    end.
  end.
end.
s
)

isPrimitive=: 3 : 0
if.  0 NB.(<'boxed') ~: < datatype y
do.
1
else.
a: -: {. (copath ::(a:"_) y)-.<,'z'
end.
)


NB. Deserializes a string into constituent objects.
NB. All serialized object and their dependencies will
NB. be reconstructed. The initially serialized object
NB. (e.g. entry-point) will be returned.
NB. Parameters:
NB. y: string representing serialized object(s).
NB. returns:
NB.   reference to the initially serialzied object.
deserialize=: 3 : 0
y=. cutopen toJ y
objList=: ''
DICTIONARY=: ''
OBJECTS=: ''
NAMES=: ''
p=. 0
c=. 0
while. 1 do.
  whilst. (<'end')~:(p+c){y do. 
    c=. c+1
  end.
  objList=: objList,dObj (p+i.c){y
  p=. p+c+1
  c=. 0
  if. (#y) <: p do. break. end.
  
end.

NB. since we are not using a 'real' dictionary, we need
NB. to search through DICTIONARY items linearly.
NB. this is slow, but the advantage is that
NB. lists of objects are deserialized into the correct
NB. list positions.
for_j. i.#OBJECTS do.
  job=: > j{OBJECTS
  'lname ref'=: >{:job
  ref=: <ref
  h=. dltb ":>{.job
  for_k. i.#DICTIONARY do.
    'hd href'=: >k{DICTIONARY
    href=: <href
    hd=: dltb ": hd
    if. hd -: h do.
      nm=. ": ". lname,'__ref'
      if. a: -: ". lname,'__ref' do.
        ". lname,'__ref=: href'
      else.
        ". lname,'__ref=:',(lname,'__ref,'),', href'
      end.
      break.
    end.
  end.
end.
{:objList
)

NB. Deserialize a single object. 
dObj=: 3 : 0
'ignore name type'=. ;:>{.y
c=. #y
NAMES=: NAMES,<":name
n=. a: conew ":type
DICTIONARY=: DICTIONARY, < n;~ name
for_i. >:i.c-1 do.
  field=. ,>i{y
  o=. '=:o' strsplit field
  m=. '=:n' strsplit field
  if. (1=#m)*.1=#o do. 
    'fname fval'=. '=:' strsplit field  
    len =: (-:#fval),2
    unpacked=. 3!:2"_[ a.{~ dfh (len&$), fval
    ". (":fname),'__n=: unpacked'
  elseif. 1=#o do.
    'fname fval'=. m
    r=: (dltb fval)
    ".((":fname),'__n=:'),":r
  elseif. 1 do.
    'fname fval'=. o
    'idxhasht su'=. ;:,>fval
    hasht=. >{: ' ' strsplit idxhasht
    OBJECTS=: OBJECTS, < hasht;<fname;n
    ". (":fname),'__n=: a:' NB. default empty
  end.
end.
n
)