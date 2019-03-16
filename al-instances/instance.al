%%% EVENTS %%%

1/throws(billy)

%%% INITIAL STATE %%%
-broken(bottle)
test(1)

%%% OUTCOME %%%%
broken(bottle)
test(1)
%%% LAWS %%%%
throws(billy) causes broken(bottle) if -broken(bottle)
effect(indirect) if broken(bottle)
