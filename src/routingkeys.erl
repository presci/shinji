-module(routingkeys).

-export([get_routing_keys/0]).


get_routing_keys()->
    Dispatch=[{"GET","/discovery", ["discovery"]},
	      {"GET", "/discovery/_", ["discovery"]},
	      {"GET", "/discovery/_/search", ["discovery", "search"]},
	      {"GET", "/discovery/_/details", ["details"]},
	      {"GET", "/discovery/_/_/name" , ["details", "name"]},
	      {"GET", "/discovery/:profile/profile", ["details", "profile"]},
	      {"GET", "/discovery/:adv0/adv", ["adv0"]},
	      {"POST", "/discovery/:adv0/adv",["adv0"]},
	      {"POST", "/discovery/:profile/profile", ["profile"]},
	      {"POST", "/discovery/_/address", ["details", "address"]}],
    Dispatch.
