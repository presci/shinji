-module(myshinji).

-export([ start/0, stop/0 ]).


start()->
    application:start(shinji),
    ok.

stop()->
    application:stop(shinji).
