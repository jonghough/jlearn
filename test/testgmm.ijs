
require jpath '~Projects/jlearn/mixtures/gmm.ijs'
coclass 'TestGMM'
coinsert 'TestBase'

create=: 3 : 0

a=: coname ''  
)


testDiagSimple=: 3 : 0
R=:  0.5 + -: ? 100 4 $ 0 NB. random in range [0.5,1]
D=: R * 100 4 $ , (=@i.) 4
gmm=: (D; 1; 'diag'; 1e_3; 1; 1e_4) conew 'GMM'
fit__gmm assertNoThrow 200
)

testFullSimple=: 3 : 0
R=:  0.5 + -: ? 100 4 $ 0 NB. random in range [0.5,1]
D=: R * 100 4 $ , (=@i.) 4
gmm=: (D; 1; 'full'; 1e_3; 1; 1e_4) conew 'GMM'
fit__gmm assertNoThrow 200
)

testTiedSimple=: 3 : 0
R=:  0.5 + -: ? 100 4 $ 0 NB. random in range [0.5,1]
D=: R * 100 4 $ , (=@i.) 4
gmm=: (D; 1; 'tied'; 1e_3; 1; 1e_4) conew 'GMM'
fit__gmm assertNoThrow 200
)

testSphericalSimple=: 3 : 0
R=:  0.5 + -: ? 100 4 $ 0 NB. random in range [0.5,1]
D=: R * 100 4 $ , (=@i.) 4
gmm=: (D; 1; 'spherical'; 1e_3; 1; 1e_4) conew 'GMM'
fit__gmm assertNoThrow 200
)




run=: 3 : 0 
testDiagSimple testWrapper 'Simple GMM test, diagonal covariance'
if. -.gmm -:'' do. destroy__gmm 0 end.
testFullSimple testWrapper 'Simple GMM test, full covariance'
if. -.gmm -:'' do. destroy__gmm 0 end.
testTiedSimple testWrapper 'Simple GMM test, tied covariance'
if. -.gmm -:'' do. destroy__gmm 0 end.
testSphericalSimple testWrapper 'Simple GMM test, spherical covariance'
if. -.gmm -:'' do. destroy__gmm 0 end.
''
)


destroy=: 3 : 0
codestroy ''
)

tg=: '' conew 'TestGMM'
run__tg 0