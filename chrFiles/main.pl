:- module(weather, [rain/0]).
:- use_module(library(chr)).
:- chr_constraint rain/0, wet/0, umbrella/0.

rain ==> wet.
rain ==> umbrella.