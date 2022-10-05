
load 'math/lapack2'
cocurrent 'jUtilsLapack'


cholesky=: 3 : 0 
'a b'=. $ y
r=.dpotrf_jlapack2_ (,'L');(,a);(|:y);(,b);,_1
'Cholesky factorization failed' assert 0=_1{::r 
l=. 3{::r
ltri_jlapack2_ |: l 
)


svd=: 3 : 0

'm n'=. $ y
mn=. m<.n
sui=. m,m
svt=. n,n
S=. mn$0
lda=. ldu=. 1>.m
U=. sui$0
VT=. svt$0
lwork=. 1 >. 0 { (((3*mn)+(m>.n))>.(5*mn)) , ((2*mn)+(m>.n))
work=. lwork$zero

r=.dgesvd_jlapack2_ (,'A');(,'A');(,m);(,n);(|:y);(,1>.m);S;U;(,1>.m);VT;(,1>.n);(lwork$0);(,lwork);,_1
NB. item 7 is the list of eigenvalues
NB. item 8 is the eigenvectors respctive to 7. 
8 7 { r
)