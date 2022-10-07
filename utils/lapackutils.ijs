
load 'math/lapack2'
cocurrent 'jUtilsLapack'


cholesky=: 3 : 0 
'a b'=. $ y
r=.dpotrf_jlapack2_ (,'L');(,a);(|:y);(,b);,_1
'Cholesky factorization failed' assert 0=_1{::r 
l=. 3{::r
ltri_jlapack2_ |: l 
)


NB. for symmetric matrices only.
svd=: 3 : 0
'matrix must be symmetric' assert y-:|:y
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
NB. 7: absolute value of eigenvalues
NB. 8: eigenvector matrix
8 7{dgesvd_jlapack2_ (,'A');(,'A');(,m);(,n);(|:y);(,1>.m);S;U;(,1>.m);VT;(,1>.n);(lwork$0);(,lwork);,_1
)


dgeev=: 3 : 0

'm n'=. $ y
r=. dgeev_jlapack2_ (,'V');(,'V');(,n);(|:y);(,1>.m);(wr=. n$0);(wi=. n$0);(vl=. (n,n)$0);(,1>.n);(vr=. (n,n)$0);(,1>.n);(lwork$0);(,lwork=. 1>.4*n);,_1
)