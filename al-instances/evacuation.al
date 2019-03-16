%%% EVENTS %%%
1/notify(b1,a1)

%%% INITIAL STATE %%%
inNeedArea(a1)
canHelp(b1,a1)
-notifyAttempted(b1,a1)
downComms(a1)
baseArea(a1)

%%% OUTCOME %%%%
-canHelp(b1,a1)

%%% LAWS %%%%
notify(b1,a1) causes notifyAttempted(b1,a1)
-canHelp(b1,a1) if notifyAttempted(b1,a1), downComms(a1)
