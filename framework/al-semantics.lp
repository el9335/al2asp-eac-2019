
% complement
compl(F,neg(F)):- fluent(F).
compl(neg(F),F):- fluent(F).

% direct effects of actions
holds(L,I2) :- step(I1), step(I2), next(I1,I2),
	       d_law(D), head(D,L), prec_h(D,I),
	       event(D,E), occurs(E,I1).

% ramifications of actions
holds(L,I) :- step(I),
	      s_law(S), head(S,L), prec_h(S,I).

% executability of actions
	:- step(I), i_law(IM), prec_h(IM,I),
	   event(IM,E), occurs(E,I).

% preconditions are satisfied
prec_h(R,I) :- step(I), all_h(R,1,I).

all_h(R,N,I) :- step(I), prec(R,N,nil).
all_h(R,N,I) :- step(I), prec(R,N,L), holds(L,I), all_h(R,N+1,I).

% consistency of state literals
	:- step(I), holds(F1,I), holds(F2,I), compl(F1,F2).

% inertia
holds(L,I2) :- step(I1), step(I2), next(I1,I2), holds(L,I1), compl(L,L'), not holds(L',I2).

% cstep is a step
step(I) :- cstep(I).

next(I1,I2) :- cstep(I1),cstep(I2),I2=I1+1.
