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
    % example:start(),
    % example:init([]),
    Worker = poolboy:checkout(pool1),
gen_server:call(Worker, "SELECT 1;"),
poolboy:checkin(pool1, Worker).
    % example:start(),
    % example:init([]),
    % example_worker:init([]),
    % io_lib:format("~p", [example:squery(pool1, "SELECT 1 as x;")]).
