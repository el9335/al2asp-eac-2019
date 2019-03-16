#!/bin/bash


python translator.py $1 
clingo 0 instance.lp framework/al-sp-semantics.lp framework/pi-causingstep.lp framework/pi-tstep.lp framework/pi-direct.lp framework/pi-indirect.lp
