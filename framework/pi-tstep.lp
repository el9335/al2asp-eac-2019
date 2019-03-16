% transition step
transitionstep(OC,J2)  :- step(J1), step(J2), next(J1,J2), ocSat(OC,J2), -ocSat(OC,J1).
-ocSat(OC,J) :- step(J), inOutcome(L,OC), not holds(L,J).
ocSat(OC,J)  :- step(J),  outcome(OC), not -ocSat(OC,J).
