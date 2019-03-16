% possible causing step
pcs(I,L,J) :- cstep(I), cstep(J), I < J,
              transitionstep(olit(L),I+1), transitionstep(theta,J). 

% not a causing step 
-causingstep(I,L,J) :- pcs(I,L,J), pcs(I',L,J), I < I', I' < J.

% causing step
causingstep(I,L,J) :- pcs(I,L,J), not -causingstep(I,L,J). 
