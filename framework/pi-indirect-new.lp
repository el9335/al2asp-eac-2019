% possible indirect cause
pic(C,I,L,J) :- subset(C), causingstep(I,L,J), not -occAt(C,I), not desubset(L,C,I).

% subset c does not occur at cstep(I)
-occAt(C,I) :-  cstep(I), inSubset(E,C), not occurs(E,I).

% for debugging
occAt(C,I) :-  subset(C), cstep(I), not -occAt(C,I).

% l is a direct effect of subset C
desubset(L,C,I) :- inSubset(E,C), directeffect(L,E,I).

% hypothetical vs counterfactual reasoning -- to distinguish between the two criteria
next(mu1(C,I),mu2(C,I)) :- pic(C,I,L,J).

% hypothetical steps
hstep(mu1(C,I)) :- next(mu1(C,I),mu2(C,I)).
hstep(mu2(C,I)) :- next(mu1(C,I),mu2(C,I)).
step(I) :- hstep(I).

% hypothetical state
holds(F,mu1(C,I)) :- fluent(F), holds(F,1), pic(C,I,L,J).

% hypothetical compound event
occurs(E,mu1(C,I)):- pic(C,I,L,J), inSubset(E,C), occurs(E,I).

test(C,I,L,J) :- pic(C,I,L,J), outcome(olit(L)), transitionstep(olit(L),mu2(C,I)).

-subsetOf(C',C) :- subset(C), subset(C'), C != C', inSubset(E,C'), not inSubset(E,C).
subsetOf(C',C,I) :- subset(C), subset(C'),C != C', occAt(C,I), occAt(C',I), not -subsetOf(C',C).

subsetPass(C,I,L,J) :- subsetOf(C',C,I), C != C', test(C', I, L, J).

indirectcause(C,I,L,J) :- test(C,I,L,J), not subsetPass(C, I, L, J).
eacindirectcause(C,eacdelim,I,eacdelim,L,eacdelim,J) :- indirectcause(C,I,L,J).
