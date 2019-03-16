
%%%%%% EVENTS %%%%%%
occurs(notify(b1,a1),1).
event(notify(b1,a1)).
cstep(1..2).
subset(c1).
inSubset(notify(b1,a1),c1).
%%%%%%%%%%%%

%%%%%% STATES %%%%%%
holds(inNeedArea(a1),1).
holds(canHelp(b1,a1),1).
holds(neg(notifyAttempted(b1,a1)),1).
holds(downComms(a1),1).
holds(baseArea(a1),1).
fluent(downComms(a1)).
fluent(notifyAttempted(b1,a1)).
fluent(baseArea(a1)).
fluent(inNeedArea(a1)).
fluent(canHelp(b1,a1)).
%%%%%%%%%%%%

%%%%%% OUTCOME %%%%%%
outcome(theta).
inOutcome(neg(canHelp(b1,a1)),theta).
outcome(olit(neg(canHelp(b1,a1)))).
inOutcome(neg(canHelp(b1,a1)),olit(neg(canHelp(b1,a1)))).
%%%%%%%%%%%%

%%%%%% ACTION DESCRIPTION %%%%%%
d_law(d1).
head(d1,not).
event(d1,notify(b1,a1)).
prec(d1,1,yAttempted(b1).
prec(d1,2,a1)).
prec(d1,3,nil).

s_law(s1).
head(s1,neg(canHelp(b1,a1))).
prec(s1,1,not).
prec(s1,2,nil).
%%%%%%%%%%%%
#show directcause/4.
#show indirectcause/4.
