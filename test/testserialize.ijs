Note 0
Copyright (C) 2022 Jonathan Hough. All rights reserved.
)

require jpath '~Projects/jlearn/serialize/serialize.ijs' 
 
coclass 'TestObj'


create=: 3 : 0
if. a. -: y do.

else. 
'a b c' =: y 
end.
)
destroy=: 3 : 0  
codestroy ''
)



coclass 'TestSerialize'
coinsert 'TestBase'

create=: 3 : 0
''
)


testSerialize1=: 3 : 0  
to =: (3;5;7) conew 'TestObj' 
s =: '' conew 'Serializer' 
sto =: serialize__s to 
tocopy =: deserialize__s sto
(3&=) assertTrue a__tocopy
(5&=) assertTrue b__tocopy
(7&=) assertTrue c__tocopy

destroy__to ''
destroy__tocopy ''
) 

testSerialize2=: 3 : 0
to =: (3;5;7) conew 'TestObj' 
to2 =: (3;5;<to) conew 'TestObj' 
s =: '' conew 'Serializer' 
sto =: serialize__s to2

destroy__to '' 
destroy__to2 '' 
tocopy =: deserialize__s sto
(3&=) assertTrue a__tocopy
(5&=) assertTrue b__tocopy  
(7&=) assertTrue c__c__tocopy 


destroy__tocopy ''
)
 

 
run=: 3 : 0 
testSerialize1 testWrapper 'Test serialize / deserialize object containing primitive members.'     
testSerialize2 testWrapper 'Test serialize / deserialize object containing object member.'     

''
)

 

destroy=: 3 : 0  
codestroy ''
)

tk=: 1 conew 'TestSerialize'
run__tk 0