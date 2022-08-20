-module(fmv1992_database_client).

-export([main/0]).

main() ->
    example:init([]),
    io_lib:format("~p", [example:squery(pool1, "SELECT 1 as x;")]).
