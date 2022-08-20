-module(example).
-behaviour(application).
-behaviour(supervisor).

-export([start/0, stop/0, squery/2, equery/3]).
-export([start/2, stop/1]).
-export([init/1, main/0]).

start() ->
    application:start(?MODULE).

stop() ->
    application:stop(?MODULE).

start(_Type, _Args) ->
    supervisor:start_link({local, example_sup}, ?MODULE, []).

stop(_State) ->
    ok.

init([]) ->
    {ok, Pools} = application:get_env(example, pools),
    PoolSpecs = lists:map(
        fun({Name, SizeArgs, WorkerArgs}) ->
            PoolArgs =
                [
                    {name, {local, Name}},
                    {worker_module, example_worker}
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

main() ->
    Pid1 = example:start(),
    Specs = example:init([]),
    % Pool1 = proplists:get_value(pool1, Pools),
    % {ok, Pools} = application:get_env(example, pools),
    erlang:throw(io_lib:format("~p", [Specs])),
    % example_worker:start_link().
    io_lib:format("~p", [example:squery(pool1, "SELECT 1 as x;")]).
