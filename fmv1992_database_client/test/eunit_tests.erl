% http://erlang.org/doc/apps/eunit/chapter.html
% `test**s**` here instead of `test` is important.
-module(eunit_tests).

-include_lib("eunit/include/eunit.hrl").

reverse_test() -> lists:reverse([1, 2, 3]).

poolboy_test() ->
    ?assertEqual(
        1,
        example:main()
    ).
