% http://erlang.org/doc/apps/eunit/chapter.html
% `test**s**` here instead of `test` is important.
-module(eunit_tests).

-include_lib("eunit/include/eunit.hrl").

reverse_test() -> lists:reverse([1, 2, 3]).

check_that_the_db_is_working() ->
    {ok, C} = epgsql:connect(#{
        host => "localhost",
        username => "fmv1992_database_user",
        password => "password_fmv1992_database_postgres",
        database => "fmv1992_database",
        port => 5999,
        timeout => 4000
    }),
    {ok, [Column], Data} = epgsql:equery(C, "SELECT 1::int as mycol;"),
    ?assertEqual([{1}], Data),
    ?assertEqual(column, erlang:element(1, Column)),
    ?assertEqual(<<"mycol">>, erlang:element(2, Column)).

poolboy_test() ->
    check_that_the_db_is_working(),
    % Start the application.
    Pid1 = fmv1992_database_client:start(),
    % Start the supervisor. This will also call `init'.
    Pid2 = fmv1992_database_client:start([], []),
    {ok, [_Column], Data} = fmv1992_database_client:equery(
        pool1, "SELECT 'POOLBOY!' as x;", []
    ),
    ?assertEqual(
        [{<<"POOLBOY!">>}],
        Data
    ).
