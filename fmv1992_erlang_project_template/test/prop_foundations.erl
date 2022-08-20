-module(prop_foundations).
-include_lib("proper/include/proper.hrl").
prop_test() ->
    ?FORALL(
        Type,
        term(),
        begin
            boolean(Type)
        end
    ).
boolean(_) -> true.
