import itertools
import sys

def translateLiteral(l):

    if "-" in l:
        return "neg(" + l.strip("-") + ")"
    else:
        return l
def replaceNeg(l):
    if "neg(" in l:
        return "-&nbsp"+l[4:len(l)-1]
    else:
        return l

def translateEvents(events):
    occurs_asp=[]
    events_asp=[]
    t_events=[]
    subsets_asp=[]

    # generate occurs and event
    max_event_index=0
    for event in events:
        try:
            e_info=event.split("/")
            occurs_asp.append("occurs(" + e_info[1].strip(" ") + "," + e_info[0].strip(" ") + ").".encode('ascii', 'ignore'))
            events_asp.append("event(" + e_info[1].strip(" ") + ").".encode('ascii', 'ignore'))
            t_events.append(e_info[1])

            if int(e_info[0]) > max_event_index:
                max_event_index = int(e_info[0])
        except:
            pass
    events_asp.append("cstep(1.." + str((max_event_index+1)) + ").")

    # generate subsets of events
    i=1
    for L in range(0, len(t_events)+1):
        for subset in itertools.combinations(t_events, L):
            if subset:
                subsets_asp.append("subset(c" + str(i) + ").".encode('ascii', 'ignore'))
                for element in subset:
                        subsets_asp.append("inSubset(" + element + ",c" + str(i) + ").".encode('ascii', 'ignore'))
                i=i+1

    return ["\n%%%%%% EVENTS %%%%%%"] +  occurs_asp + events_asp + subsets_asp + ["%%%%%%%%%%%%"]

def translateStates(states):
    states_asp=[]
    fluents=set()

    for state in states:
        if not state.startswith('\n'):
            states_asp.append("holds(" + translateLiteral(state.strip("\n") ).strip(" ")+ ",1).".encode('ascii', 'ignore'))
            fluents.add("fluent(" + state.strip(" ").strip("-").strip("\n") + ").".encode('ascii', 'ignore'))

    return ["\n%%%%%% STATES %%%%%%"] +  states_asp + list(fluents) + ["%%%%%%%%%%%%"]

def translateOutcome(outcome):

    outcome_asp=["outcome(theta)."]
    i = 0
    outcome_fluents=set()
    for literal in outcome:
        literal=literal.strip("\n")
        if not literal.startswith('\n'):
            outcome_asp.append("inOutcome(" + translateLiteral(literal.strip(" ")).strip("\n") + ",theta).")
            outcome_asp.append("outcome(olit(" + translateLiteral(literal.strip(" ")).strip("\n") + ")).")
            outcome_asp.append("inOutcome(" + translateLiteral(literal.strip(" ")).strip("\n") + ",olit(" + translateLiteral(literal.strip(" ").strip("\n")) + ")).")

            i=i+1

    return ["\n%%%%%% OUTCOME %%%%%%"] + outcome_asp + list(outcome_fluents) + ["%%%%%%%%%%%%"]

def translateAD(ad):

    # Action description ad_asp is "union" of d_laws, s_laws, i_laws
    d_laws=[]
    s_laws=[]
    i_laws=[]

    num_d_laws=0
    num_s_laws=0
    num_i_laws=0

    for law in ad:
        law=law.strip("\n")
        if "causes" in law:
            num_d_laws = num_d_laws + 1
            d="d" + str(num_d_laws)
            d_laws.append("d_law("+ d + ").")

            # rule[0] is event, rule[1] is head and preconditions as a string
            rule = law.split("causes")
            event = rule[0].strip(" ")

            try:
                head_precs = rule[1].split("if")
                head = translateLiteral(head_precs[0].strip(" "))
                precs = head_precs[1].split(",")

                precs=[item.strip(" ") for item in precs]
                precs=[translateLiteral(item) for item in precs]
            except:
                head = translateLiteral(rule[1].strip(" "))
                precs = None

            d_laws.append("head(" + d +"," + head + ").")
            d_laws.append("event(" + d +"," + event + ").")

            i=1
            if precs:
                for prec in precs:
                    d_laws.append("prec(" + d + "," + str(i) + "," + translateLiteral(prec) + ").")
                    i=i+1
            else:
                pass

            d_laws.append("prec(" + d + "," + str(i) + ",nil).\n")

        elif " if " in law:
            num_s_laws = num_s_laws + 1
            s="s" + str(num_s_laws)
            s_laws.append("s_law(" + s + ")." )

            rule = law.split("if")

            head = translateLiteral(rule[0].strip(" "))
            precs = rule[1].split(",")
            precs=[item.strip(" ") for item in precs]

            s_laws.append("head(" + s +"," + head + ").")

            i=1
            if precs:
                for prec in precs:
                    s_laws.append("prec(" + s + "," + str(i) + "," + translateLiteral(prec) + ").")
                    i=i+1
            else:
                pass

            s_laws.append("prec(" + s + "," + str(i) + ",nil).")

        elif "impossible_if" in law:
            num_i_laws = num_i_laws + 1
            im="im" + str(num_i_laws)
            i_laws.append("i_law(" + im + ").")

            rule = law.split("impossible_if")
            event = rule[0].strip(" ")
            precs = rule[1].split(",")
            precs=[item.strip(" ") for item in precs]

            i_laws.append("head(" + im +"," + head + ").")

            i=1
            if precs:
                for prec in precs:
                    i_laws.append("prec(" + im + "," + str(i) + "," + translateLiteral(prec) + ").")
                    i=i+1
            else:
                pass

            i_laws.append("prec(" + im + "," + str(i) + ",nil).")

    return ["\n%%%%%% ACTION DESCRIPTION %%%%%%"] + d_laws + s_laws + i_laws + ["%%%%%%%%%%%%"]


events_delim="%%% EVENTS %%%\n"
initial_state_delim="%%% INITIAL STATE %%%\n"
outcome_delim="%%% OUTCOME %%%%\n"
laws_delim="%%% LAWS %%%%\n"


file = sys.argv[1]

fo=open(file,"r")
lines=fo.readlines()

events = list(map(lambda x: x.strip("\n"), lines[1:lines.index(initial_state_delim)]))
initial_state = lines[lines.index(initial_state_delim)+1:lines.index(outcome_delim)]
outcome = lines[lines.index(outcome_delim)+1:lines.index(laws_delim)]
laws =lines[lines.index(laws_delim)+1:len(lines)]

program=""
asp_events = translateEvents(events)
for ae in asp_events:
    program = program + ae + "\n"

asp_states = translateStates(initial_state)
for state in asp_states:
    program = program + state + "\n"

asp_outcome = translateOutcome(outcome)
for oc in asp_outcome:
    program = program + oc + "\n"

asp_laws = translateAD(laws)
for law in asp_laws:
    program = program + law + "\n"

program = program + "#show directcause/4." + "\n"
program = program +  "#show indirectcause/4." + "\n"

print program

fw = open("instance.lp","w")
fw.write(program)
