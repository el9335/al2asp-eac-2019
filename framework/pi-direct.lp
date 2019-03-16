directeffect(L,E,I) :- cstep(I), d_law(D), head(D,L), event(D,E), prec_h(D,I), occurs(E,I).

directcause(E,I,L,J) :- causingstep(I,L,J), directeffect(L,E,I).

eacdirectcause(E,eacdelim,I,eacdelim,L,eacdelim,J) :- directcause(E,I,L,J).
