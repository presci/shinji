-module(shinji_test).

-include_lib("amqp_client/include/amqp_client.hrl").


-export([start/0]).


start()->	
    {ok, Connection} = amqp_connection:start(#amqp_params_network{}),
    {ok, Channel} = amqp_connection:open_channel(Connection),
    Declare = #'queue.declare'{queue = <<"myqueue">>},
    #'queue.declare_ok'{} = amqp_channel:call(Channel, Declare),
    ok.



