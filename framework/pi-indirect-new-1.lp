% possible indirect cause
pic(C,I,L,J) :- subset(C), causingstep(I,L,J), not -occAt(C,I), not desubset(L,C,I).

% subset c does not occur at cstep(I)
-occAt(C,I) :-  cstep(I), inSubset(E,C), not occurs(E,I).

% for debugging
occAt(C,I) :-  subset(C), cstep(I), not -occAt(C,I).

% l is a direct effect of subset C
desubset(L,C,I) :- inSubset(E,C), directeffect(L,E,I).

%aspcs(C,L,I) :- pic(C,I,L,J), not -aspcs(C,L,I).
% not a smallestpossiblycausingsubset
%-aspcs(C,L,I) :- pic(C,I,L,J), cstep(I), fluent(L),
%			   subset(C'), C!=C',
%			   pic(C',I,L,J),
%			   #count{E:inSubset(E,C)}=X,
%			   #count{E:inSubset(E,C')}=X',
%			   X>X'.

%-aspcs(C,L,I) :- test(C,I,L,J), cstep(I), fluent(L),
%			   subset(C'), C!=C',
%			   test(C',I,L,J),
%			   #count{E:inSubset(E,C)}=X,
%			   #count{E:inSubset(E,C')}=X',
%			   X>X'.

-smaller(C,L,I) :- subset(C),subset(C'),C!=C',test(C,I,L,J),test(C',I,L,J),#count{E:inSubset(E,C)}=X,
#count{E:inSubset(E,C')}=X',X>X'.

% indirect cause if possible IC but not a smallest possibly IC subset
%-indirectcause(C,I,L,J) :- test(C,I,L,J), -aspcs(C,L,I).

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

test(C,I,L,J) :- pic(C,I,L,J),
			outcome(olit(L)), transitionstep(olit(L),mu2(C,I)).

indirectcause(C,I,L,J) :- test(C,I,L,J), not -smaller(C,L,I).

% indirect cause
%indirectcause(C,I,L,J) :- pic(C,I,L,J),
%				outcome(olit(L)), transitionstep(olit(L),mu2(C,I)).

% show the event(s) of the causing compound event
%ics(c1) :- indirectcause(C,I,L,J).
%indirectcausecontains(C,E) :- inSubset(E,C), indirectcause(C,I,L,J).

eacindirectcause(C,eacdelim,I,eacdelim,L,eacdelim,J) :- indirectcause(C,I,L,J).
