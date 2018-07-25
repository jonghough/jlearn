Note 0
Copyright (C) 2017 Jonathan Hough. All rights reserved.
)

cocurrent 'jLearnImpute'
 

NB. Impute the dataset's column entries using the modal
NB. value of the column.
NB. Parameters:
NB. x: Column index
NB. y: Dataset to imput the values of.
imputeColumnWithMode=: 4 : 0"0 _
c=. x{"1 y
idx=. a:=c
w=. c{~ I. -. idx
mode=. {.w{~ I. (=>./) #/.~ w
idxs=. (I. idx)
mode (idxs}) c

)

imputeColumnWithMean=: 4 : 0"0 _
c=. x{"1 y
idx=. a:=c
w=. c{~ I. -. idx
meanval=. < (+/ % #) >w
idxs=. (I. idx)
meanval (idxs}) c
)

imputeWithMode=: 3 : 0
|: (i.{:$y) imputeColumnWithMode y
)

imputeWithMean=: 3 : 0
|: (i.{:$y) imputeColumnWithMean y
)


NB. Imputes the given column using mode, if the
NB. column contains non-numeric datatypes, otherwise
NB. uses the mean of the values in the column.
NB. Parameters:
NB. x: Index of column to impute
NB. y: Dataset
NB. returns:
NB.   Imputed column of the dataset.
smartImputeColumn=: 4 : 0"0 _
c=. x{"1 y
idx=. a:=c
w=. c{~ I. -. idx
types=. ~. datatype&.> w
if. (<'literal') e. types do.
  x imputeColumnWithMode y
else.
  x imputeColumnWithMean y
end.
)


NB. Will impute the missing values by mean value if
NB. all data in the column is numeric, otherwise
NB. will use mode of the column.
NB. Parameters:
NB. y: Dataset to impute
NB. returns:
NB.   imputed dataset
smartImpute=: 3 : 0
n=. i.{:$y
M=. y
r=. ''
smoutput n
for_i. n do.
  if. i = 0 do.
    r=. i smartImputeColumn M
  else. r=. r,.i smartImputeColumn M
  end.
end.
r
)





