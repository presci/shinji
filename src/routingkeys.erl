-module(routingkeys).

-export([get_routing_keys/0]).


get_routing_keys()->
            Dispatch=[{"GET","/discovery"},
{"GET", "/discovery/_"},
{"GET", "/discovery/_/search"},
{"GET", "/discovery/_/details"},
{"GET", "/discovery/_/_/name"},
{"GET", "/discovery/:profile/profile"},
{"GET", "/discovery/:adv0/adv"},
{"POST", "/discovery/:adv0/adv"},
{"POST", "/discovery/:profile/profile"},
{"POST", "/discovery/_"},
		      {"POST", "/discovery/_/address"}],
                Dispatch.
