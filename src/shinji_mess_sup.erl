-module(shinji_mess_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, brutal_kill, Type, [I]}).


start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
    RestartStrategy = { one_for_one, 1, 60 },
    Shinji_tcp = ?CHILD(shinji_mess, worker ),
    {ok, { RestartStrategy, Shinji_tcp } }.

