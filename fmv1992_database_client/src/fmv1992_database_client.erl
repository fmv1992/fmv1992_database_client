-module(fmv1992_database_client).

% -define(LARGE_BINARY_SIZE, 1 * 1024 * 1024 * 1024 - erlang:round(1.0e4)).

-behaviour(application).
-behaviour(supervisor).

-export([start/0, stop/0, squery/2, equery/3]).
-export([start/2, stop/1]).
-export([init/1]).

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

start(_Type, _Args) ->
    supervisor:start_link({local, example_sup}, ?MODULE, []).

stop(_State) ->
    ok.

init([]) ->
    {ok, Pools} = application:get_env(fmv1992_database_client, pools),
    PoolSpecs = lists:map(
        fun({Name, SizeArgs, WorkerArgs}) ->
            PoolArgs =
                [
                    {name, {local, Name}},
                    {worker_module, fmv1992_database_client_worker}
                ] ++ SizeArgs,
            poolboy:child_spec(Name, PoolArgs, WorkerArgs)
        end,
        Pools
    ),
    {ok, {{one_for_one, 10, 10}, PoolSpecs}}.

squery(PoolName, Sql) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        gen_server:call(Worker, {squery, Sql})
    end).

equery(PoolName, Stmt, Params) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        gen_server:call(Worker, {equery, Stmt, Params})
    end).
