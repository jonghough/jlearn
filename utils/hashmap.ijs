coclass 'HASHMAP'
entries=: ''
count=: ''
MAX=: 20

NB. Initialize and create buckets
NB. 	y: Number of buckets
create=: monad define
MAX =: y
for_j. i. MAX do.
  entries=: entries, (conew 'ENTRY')
end.
)

NB. Gets the size of the hashmap,
NB. number of key/value pairs.
size=: monad define
count=. 0
for_j. i. MAX do.
  ent=. j{entries
  if. isSet__ent do. count=. count + getSize__ent ''
  end.
end.
count
)

NB. set a new key value pair.
NB. Should be boxed pair (key;value)
set=: monad define
rk=. >0{y NB. raw key
hk=. hash rk NB. hashed key
val=. >1{y NB. value
i=. conew 'ENTRY'
create__i rk;hk;val
hk append i
''
)

NB. Returns list of all key value pairs
NB. in an arbitrary order.
enumerate=: monad define
result=. ''
for_j. i. MAX do.
  ent=. j{entries
  if. isSet__ent do.
    result=. result, (enumerate__ent '')
  end.
end.
result
)


NB. Append the new Entry to the hashmap.
append=: dyad define
ent=. x { entries
newent=. y
NB. if empty slot, put new item in it.
if. 0 = isSet__ent do.
  entries=: y x} entries
NB. if not empty, but raw keys are identical, refill.
elseif. rawKey__ent -: rawKey__newent do.
  entries=: newent x} entries
NB. else append to the last in linkedlist
elseif. 1 do.
  appendToLast__ent y
end.
)

NB. Get the value for the given key.
get=: monad define
ky=. y
hk=. hash ky
ent=. hk{entries
if. 0 = isSet__ent do. 'ERROR' return.
elseif. key__ent -: hk do.
  matches__ent ky
end.
)

NB. Removes a single entry form the hashmap, if
NB. the given key matches the key of the entry.
remove=: monad define
ky=. y
hk=. hash ky
ent=. hk{entries
NB. if no entry, then return.
if. 0 = isSet__ent do. 0
NB. keys match...
elseif. key__ent -: hk do.
NB. check if raw keys match...
  if. ky -: rawKey__ent do.
NB. linked list is 0 so remove this item.
    if. 0 = # next__ent do.
      reset__ent ''
      1
NB. linked list has elements so put
NB. next element in bucket (becomes head of list).
    else. entries=: next__ent hk} entries
      reset__ent ''
      1
    end.
NB. raw keys do not match, check next element.
  else.
    nextent=. next__ent
    ent removeFromList__nextent y
  end.
end.
)

NB. Returns 1 if vey value pair exists for the
NB. given key, otherwise returns 0.
containsValue=: monad define
ky=. y
hk=. hash ky
ent=. hk{entries
if. 0 = isSet__ent do. 0
elseif. key__ent = hk do.
  contains__ent ky
end.
)

NB. Hash the key.
hash=: monad define
h=. a.i.": y
h=. +/h
h1=. 3 (33 b.) h
h2=. 13 (33 b.) h
h3=. (h2 * 13) - (12309 * h) + *:h
h=. h XOR h1 XOR h2
h=. h AND (h3 XOR 10929321)
h=. h XOR (7 ( 33 b.) h)
h=. (_34221 * h) + (h XOR h2) + ((h1 * h3) XOR 32102039191)
MAX | h
)

destroy=: codestroy




NB. =============== ENTRY CLASS =============

NB. Entry class contains key value pair and "pointer"
NB. to potential next entry in LinkedList fashion.
coclass 'ENTRY'
key=: '' 		NB. The key (hashed)
value=: '' 	NB. The value
next=: '' 		NB. The next value, if any
rawKey=: '' 	NB. The raw, unhashed, key
isSet=: 0 		NB. flag for instantiated or not.

NB. Instantiate the Entry object.
create=: 3 : 0
rawKey=: >0{y
key=: >1{y
value=: 2}.y NB. strip the first two
isSet=: 1
)

NB. Returns 1 if this Entry contains the key
NB. value pair for the given key.
contains=: monad define
rk=: y
if. isSet = 0 do. 0
elseif. (<rawKey) = <rk do.
  1
elseif. 0 = # next do. 0
elseif. 1 do.
  contains__next y
end.
)

NB. Returns this key value pair and the
NB. list of key value pairs of the tail of the 
NB. linked list.
enumerate=: monad define
if. 0 = # next do.
  <(rawKey; value)
else.
  (<(rawKey;value)),( enumerate__next '')
end.
)

NB. Tests if the key matches and if so returns the value,
NB. else sends key to the next item in linkedlist.
matches=: monad define
rk=. y
rk =. ($rawKey) $ rk
if. isSet = 0 do. 'ERROR' return.
elseif. (rawKey) -: (rk) do.
  value
elseif. 1 do.
  matches__next y
end.
)

NB. Removes this item from the current linked list.
removeFromList=: dyad define
rk=. y NB. a raw key
last=. x NB. the last entry in this list
if. rk -: rawKey do.
  next__last=: next NB. relink the last/next items.
  reset ''
  1
elseif. 0 = # next do. 0
elseif. 1 do. next__last removeFromList__next y end.
)


getSize=: monad define
if. 0 = # next do. 1
else. 1 + getSize__next ''
end.
)

appendToLast=: monad define
if. 0 = # next do.
  next=: y
else.
  appendToLast__next y
end.
)

NB. Resets this item.
reset=: monad define
isSet=: 0
key=: ''
value=: ''
next=: ''
rawKey=: ''
)

destroy=: codestroy
