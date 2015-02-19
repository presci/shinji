-module(hole_router).

-export([dispatch/0]).
-export([get_dispatch/1]).
-export([printlist/1]).
%% test function
-export([test00/0,test01/0,test02/0,test03/0, test04/0, test05/0, test06/0, test07/0, test08/0, test09/0, test10/0, test11/0]).
-export([test_match_route01/0, test_match_route02/0]).
-export([test_dispatch_for/0]).


dispatch()->
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

get_dispatch(Targ)->
        get_dispatch(Targ, dispatch()).
get_dispatch(Targ, Routes)->
    dispatch_for(Targ, Routes).

dispatch_for(Targ, Routes) ->
    {M, U} = Targ,
    K=[RT || RT = {Method, J} <- Routes,
	   length(string:tokens(U, "$/")) == length(string:tokens(J, "$/")) ,
	   match_route(string:tokens(U, "$/"), string:tokens(J, "$/")), match_method(M, Method)
      ],
    K.
    
test_dispatch_for()->
    dispatch_for({"GET", "/discovery/hello"}, [{"GET", "/discovery/_"}, {"GET", "/discovery/_/details"}]).

match_method(M0, M1) when M0 =:= M1 ->
    true;
match_method(M0, M1) when M0 =/= M1->
    false.



match_route(T, R) when length(T) =/= length(R)->
    false;
match_route(T, R) ->
    match_route0(T, R, []).
test_match_route01()->
    match_route(["_", "discovery"], ["search", "_", "discovery"]).
test_match_route02()->
    match_route(["leaf", "discovery"], [ "_", "discovery"]).


match_route0([X|Targ], [Y|Route], A) when X=:= Y orelse Y=:= "_" ->
    match_route0(Targ, Route, A ++ [Y]);
match_route0([X|_Targ], [Y|_Route], _A) when X=/= Y  andalso Y =/= "_" ->
    case string:substr(Y, 1,1) =:= ":" of
	true ->
	    match_route0(_Targ, _Route,_A ++ ["_"] );
	false ->
	    false
	end;
match_route0([], [], _) ->
    true.

    


printlist([X|Rest])->  
    io:format(X),
    io:format("~n"),
    printlist(Rest);
printlist([]) -> 
    ok.


    
%%%
%%%
%%%
test00()->
    get_dispatch({"GET", "/discovery/local"}).
test01()->
    get_dispatch({"GET", "/discovery/hello/search"}).
test02()->
    get_dispatch({"GET", "/discovery/lucas/loe/name"}).
test03()->
    get_dispatch({"GET", "/discovery/0012/details"}).
test04()->
    get_dispatch( {"POST", "/discovery/helloworld"}).
test05()->
    get_dispatch({"POST", "/discovery/iamherefornookie/address"}).
test06()->
    get_dispatch( {"GET", "/discovery/01223/profile"}).
test07()->
    get_dispatch({"POST", "/discovery/01223/profile"}).
test08()->
    get_dispatch( {"GET", "/discovery/helloworld/adv"}).
test09()->
    get_dispatch({"POST", "/discovery/iamherefornookie/adv"}).
test10()->
    get_dispatch({"POST", "/discovery/roadie/leaf/carl"}).
test11()->
    get_dispatch({"POST", "/discovery/fist/offury"}).
