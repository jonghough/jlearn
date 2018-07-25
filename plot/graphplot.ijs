NB. Implementation of graph plotting.
NB. TODO

require 'plot'
require 'numeric trig'

cocurrent 'jlplot'


plotSurface=: 3 : 0
'X Y Z'=.y
assert. (#,Z) = (#X)*(#Y)
title=. >3{y
view=.>4{y

pd 'reset'
pd 'title ',": title
pd X;Y;Z
pd 'type surface'
pd 'viewpoint ',":view
pd 'show'
NB. pd 'save jpg doom'

)

plotContour =: 3 : 0
'X Y Z'=.y
assert. (#,Z) = (#X)*(#Y)
title=. >3{y


pd 'reset'
pd 'title ',": title
pd X;Y;Z
pd 'type contour'
pd 'show'
NB. pd 'save jpg doom'

)