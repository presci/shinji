-module(shinji_mess).

-behaviour(gen_server).

-include_lib("amqp_client/include/amqp_client.hrl").

-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).


-export([create_queues/0]).

-define(SERVER, ?MODULE). 
-define(REPLY_TO, "replyqueue").
-define(EXCHANGE, "shinjiexchange").
-define(QUEUE, "shinjiqueue").


start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


init([]) ->
    State = ets:new(corr_pid, [ordered_set, named_table]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


create_queues()->
    Routingkey = routingkeys:get_routing_keys(),
    ConnParams = #amqp_params{username = <<"guest">> , 
			      password = <<"guest">>,
			      virtual_host = <<"/">>, 
			      host = <<"localhost">>,
			      port = 5672 },    
    
    {ok, Connection} = amqp_connection:start(network, ConnParams),    
    {ok, Chann} = amqp_connection:open_channel(Connection),
    amqp_channel:call(Chann, 
		      #'exchange.declare'{
			exchange = ?EXCHANGE, 
			type = <<"x-recent-history">>, 
			durable = true}),    
    amqp_channel:call(Chann, 
		      #'queue.declare'{queue = ?QUEUE}),    
    amqp_channel:call(Chann, 
		      #'queue.declare'{queue = ?REPLY_TO }),    
    create_routing(Routingkey, Chann).

create_routing([{Method, Uri}|T], Chann)->
    J=string:join([Method, Uri], ":"),
    amqp_channel:call(Chann, 
		      #'queue.bind'{
			queue = ?QUEUE, 
			exchange = ?EXCHANGE, 
			routing_key = J}), 
    create_routing(T, Chann);
create_routing([], _ ) ->
    ok.
