-module(shinji_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    Shinji_tcp_sup = ?CHILD(shinji_tcp_sup, supervisor),
    Shinji_mess_sup = ?CHILD(shinji_mess_sup, supervisor),
    Children = [ Shinji_tcp_sup, Shinji_mess_sup],
    RestartStrategy = { one_for_one , 4, 2000 },
    {ok, { RestartStrategy , Children } }.

