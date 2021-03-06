%%%----------------------------------------------------------------------
%%% Copyright (c) 2011, Alkis Gotovos <el3ctrologos@hotmail.com>,
%%%                     Maria Christakis <mchrista@softlab.ntua.gr>
%%%                 and Kostis Sagonas <kostis@cs.ntua.gr>.
%%% All rights reserved.
%%%
%%% This file is distributed under the Simplified BSD License.
%%% Details can be found in the LICENSE file.
%%%----------------------------------------------------------------------
%%% Authors     : Alkis Gotovos <el3ctrologos@hotmail.com>
%%%               Maria Christakis <mchrista@softlab.ntua.gr>
%%% Description : Scheduler unit tests
%%%----------------------------------------------------------------------

-module(sched_tests).

-include_lib("eunit/include/eunit.hrl").

-define(TEST_ERL_PATH, ["./resources/test.erl"]).
-define(RH_PATH, ["./resources/manolis/rush_hour.erl",
		  "./resources/manolis/search.erl"]).
-define(TR_PATH, ["./resources/shootout/thread_ring.erl"]).

%% Spec for auto-generated test/0 function (eunit).
-spec test() -> 'ok' | {'error', term()}.


-spec system_test_() -> term().

system_test_() ->
    Setup = fun() -> log:start() end,
    Cleanup = fun(_Any) -> log:stop() end,
    Test01 = {"2 proc | spawn | normal",
	      fun(_Any) -> test_ok({test, test_spawn, []},
				   [{0, 1}, {1, 2}, {inf, 2}])
	      end},
    Test02 = {"2 proc | send (!) | normal",
	      fun(_Any) -> test_ok({test, test_send, []},
				   [{0, 1}, {1, 3}, {inf, 3}])
	      end},
    Test03 = {"2 proc | send (erlang:send) | normal",
	      fun(_Any) -> test_ok({test, test_send_2, []},
				   [{0, 1}, {1, 3}, {inf, 3}])
	      end},
    Test04 = {"1 proc | receive | deadlock",
	      fun(_Any) -> test_error({test, test_receive, []},
				      "Deadlock",
				      [{0, 1, 1}, {inf, 1, 1}])
	      end},
    Test05 = {"2 proc | receive | deadlock",
	      fun(_Any) -> test_error({test, test_receive_2, []},
				      "Deadlock",
				      [{0, 1, 1}, {inf, 1, 1}])
	      end},
    Test06 = {"2 proc | send - receive | normal",
	      fun(_Any) -> test_ok({test, test_send_receive, []},
				   [{0, 1}, {1, 2}, {2, 3}, {inf, 3}])
	      end},
    Test07 = {"2 proc | send - receive | normal",
	      fun(_Any) -> test_ok({test, test_send_receive_2, []},
				   [{0, 1}, {1, 2}, {2, 3}, {inf, 3}])
	      end},
    Test08 = {"2 proc | send - receive | normal",
	      fun(_Any) -> test_ok({test, test_send_receive_2, []},
				   [{0, 1}, {1, 2}, {2, 3}, {inf, 3}])
	      end},
    Test09 = {"2 proc | receive after - no patterns | normal",
	      fun(_Any) -> test_ok({test, test_receive_after_no_patterns, []},
				   [{0, 1}, {1, 2}, {2, 3}, {inf, 3}])
	      end},
    Test10 = {"2 proc | receive after - with pattern | assert",
	      fun(_Any) ->
		      test_error({test, test_receive_after_with_pattern, []},
				 "Assertion violation",
				 [{0, 1, 0}, {1, 3, 1}, {2, 5, 2},
				  {3, 6, 3}, {inf, 6, 3}])
	      end},
    Test11 = {"2 proc | receive after - check after clause preemption "
	      "| assert",
	      fun(_Any) -> test_error({test, test_after_clause_preemption, []},
				      "Assertion violation",
				      [{0, 1, 0}, {1, 4, 2}, {2, 7, 4},
				       {3, 9, 6}, {inf, 9, 6}])
	      end},
    Test12 = {"2 proc | receive after infinity - with pattern "
	      "| deadlock",
	      fun(_Any) ->
		      test_error({test,
				  test_receive_after_infinity_with_pattern, []},
				 "Deadlock",
				 [{0, 1, 1}, {inf, 1, 1}])
	      end},
    Test13 = {"2 proc | receive after infinity - no patterns"
	      "| deadlock",
	      fun(_Any) ->
		      test_error({test,
				  test_receive_after_infinity_no_patterns, []},
				 "Deadlock",
				 [{0, 1, 1}, {inf, 1, 1}])
	      end},
    Test14 = {"2 proc | nested send & receive, process blocks twice | normal",
	      fun(_Any) ->
		      test_ok({test, test_nested_send_receive_block_twice, []},
			      [{0, 1}, {1, 2}, {2, 4}])
	      end},
    Test15 = {"2 proc | link after spawn race | exception",
	      fun(_Any) -> test_error({test, test_spawn_link_race, []},
				      "Exception",
				      [{0, 1, 0}, {1, 3, 1}, {inf, 3, 1}])
	      end},
    Test16 = {"2 proc | link, trap_exit and receive 'EXIT' message "
	      "| deadlock",
	      fun(_Any) -> test_error({test, test_link_receive_exit, []},
				      "Deadlock",
				      [{0, 1, 1}, {1, 3, 1}, {inf, 3, 1}])
	      end},
    Test17 = {"2 proc | spawn_link, trap_exit and receive 'EXIT' message "
	      "| deadlock",
	      fun(_Any) -> test_error({test, test_spawn_link_receive_exit, []},
				      "Deadlock",
				      [{0, 1, 1}, {1, 2, 1}, {inf, 2, 1}])
	      end},
    Test18 = {"2 proc | link - unlink | deadlock",
	      fun(_Any) -> test_error({test, test_link_unlink, []},
				      "Deadlock",
				      [{0, 1, 1}, {1, 3, 3}, {2, 5, 5},
				       {3, 6, 6}, {inf, 6, 6}])
	      end},
    Test19 = {"2 proc | spawn_link - unlink | deadlock",
	      fun(_Any) -> test_error({test, test_spawn_link_unlink, []},
				      "Deadlock",
				      [{0, 1, 1}, {1, 2, 2}, {2, 3, 3},
				       {inf, 3, 3}])
	      end},
    Test20 = {"2 proc | spawn_link - unlink | normal",
	      fun(_Any) -> test_ok({test, test_spawn_link_unlink_2, []},
				      [{0, 1}, {1, 4}, {inf, 4}])
	      end},
    Test21 = {"2 proc | spawn_link - unlink | assert",
	      fun(_Any) -> test_error({test, test_spawn_link_unlink_3, []},
				      "Assertion violation",
				      [{0, 1, 0}, {1, 4, 1}, {inf, 4, 1}])
	      end},
    Test22 = {"2 proc | trap_exit timing | assert",
	      fun(_Any) -> test_error({test, test_trap_exit_timing, []},
				      "Assertion violation",
				      [{0, 1, 0}, {1, 4, 1}, {inf, 4, 1}])
	      end},
    Test23 = {"2 proc | register after spawn race | exception",
	      fun(_Any) -> test_error({test, test_spawn_register_race, []},
				      "Exception",
				      [{0, 1, 0}, {1, 3, 1}, {2, 4, 1},
				       {inf, 4, 1}])
	      end},
    Test24 = {"2 proc | register - unregister | exception",
	      fun(_Any) -> test_error({test, test_register_unregister, []},
				      "Exception",
				      [{0, 1, 1}, {1, 2, 1}, {2, 3, 1},
				       {3, 5, 1}, {inf, 5, 1}])
	      end},
    Test25 = {"2 proc | register - whereis | assert",
	      fun(_Any) -> test_error({test, test_whereis, []},
				      "Assertion violation",
				      [{0, 1, 1}, {1, 2, 1}, {2, 4, 2},
				       {inf, 4, 2}])
	      end},
    Test26 = {"2 proc | receive after - block expression action | normal",
	      fun(_Any) ->
		      test_ok({test, test_receive_after_block_expr_action, []},
			      [{0, 1}, {inf, 1}])
	      end},
    Test27 = {"2 proc | monitor - exit race | assert",
	      fun(_Any) -> test_error({test, test_monitor_unexisting, []},
				      "Assertion violation",
				      [{0, 1, 0}, {1, 4, 1}, {inf, 4, 1}])
	      end},
    Test28 = {"2 proc | spawn_monitor | normal",
	      fun(_Any) -> test_ok({test, test_spawn_monitor, []},
				   [{0, 1}, {inf, 1}])
	      end},
    Test29 = {"2 proc | spawn_monitor - demonitor | assert",
	      fun(_Any) -> test_error({test, test_spawn_monitor_demonitor, []},
				      "Assertion violation",
				      [{0, 1, 0}, {1, 4, 1}, {inf, 4, 1}])
	      end},
    Test30 = {"2 proc | spawn_monitor - demonitor(Ref, []) | assert",
	      fun(_Any) ->
		      test_error({test, test_spawn_monitor_demonitor_2, []},
				 "Assertion violation",
				 [{0, 1, 0}, {1, 4, 1}, {inf, 4, 1}])
	      end},
    Test31 = {"2 proc | spawn_monitor - demonitor(Ref, [flush]) | normal",
	      fun(_Any) -> test_ok({test, test_spawn_monitor_demonitor_3, []},
				   [{0, 1}, {1, 4}, {inf, 4}])
	      end},
    Test32 = {"2 proc | spawn_monitor - demonitor(Ref, [info]) | assert",
	      fun(_Any) ->
		      test_error({test, test_spawn_monitor_demonitor_4, []},
				 "Assertion violation",
				 [{0, 1, 0}, {1, 3, 1}, {inf, 3, 1}])
	      end},
    Test33 = {"2 proc | spawn_monitor - demonitor(Ref, [flush, info]) | assert",
	      fun(_Any) ->
		      test_error({test, test_spawn_monitor_demonitor_4, []},
				 "Assertion violation",
				 [{0, 1, 0}, {1, 3, 1}, {inf, 3, 1}])
	      end},
    Test34 = {"2 proc | spawn_opt (link), trap_exit and receive 'EXIT' message "
	      "| deadlock",
	      fun(_Any) ->
		      test_error({test, test_spawn_opt_link_receive_exit, []},
				 "Deadlock",
				 [{0, 1, 1}, {1, 2, 1}, {inf, 2, 1}])
	      end},
    Test35 = {"2 proc | spawn_opt (monitor) | normal",
	      fun(_Any) -> test_ok({test, test_spawn_opt_monitor, []},
				   [{0, 1}, {inf, 1}])
	      end},
    Test36 = {"2 proc | erlang:send/3 (nosuspend) | normal",
	      fun(_Any) -> test_ok({test, test_send_2, []},
				   [{0, 1}, {1, 3}, {inf, 3}])
	      end},
    Test37 = {"1 proc | halt/0 | normal",
	      fun(_Any) -> test_ok({test, test_halt_0, []},
				   [{0, 1}, {inf, 1}])
	      end},
    Test38 = {"1 proc | halt/1 | normal",
	      fun(_Any) -> test_ok({test, test_halt_1, []},
				   [{0, 1}, {inf, 1}])
	      end},
    Test39 = {"2 proc | Variable module:function call (erlang:spawn) | normal",
	      fun(_Any) -> test_ok({test, test_var_mod_fun, []},
				   [{0, 1}, {1, 2}, {inf, 2}])
	      end},
    Test40 = {"3 proc | 2 available procs after block  | normal",
	      fun(_Any) -> test_ok({test, test_3_proc_receive_exit, []},
				   [{0, 3}, {1, 4}, {2, 5}, {inf, 5}])
	      end},
    Test41 = {"3 proc | 3 proc send receive (check complex blocks) | normal",
	      fun(_Any) -> test_ok({test, test_3_proc_send_receive, []},
				   [{0, 8}, {1, 44}, {2, 136}, {3, 275},
				    {4, 392}, {5, 458}, {6, 481}, {7, 483},
				    {inf, 483}])
	      end},
    Test42 = {"2 proc | Manolis' RushHour - workers = 2, pb = 0 | normal",
	      fun(_Any) -> test_ok({rush_hour, test_2workers, []},
				   [{0, 768}], ?RH_PATH)
	      end},
    Test43 = {"5 proc | Shootout thread ring | normal",
	      fun(_Any) -> test_ok({thread_ring, test1, []},
				   [{0, 1}, {inf, 1}], ?TR_PATH)
	      end},
    Tests = [Test01, Test02, Test03, Test04, Test05, Test06,
	     Test07, Test08, Test09, Test10, Test11, Test12,
	     Test13, Test14, Test15, Test16, Test17, Test18,
	     Test19, Test20, Test21, Test22, Test23, Test24,
	     Test25, Test26, Test27, Test28, Test29, Test30,
	     Test31, Test32, Test33, Test34, Test35, Test36,
	     Test37, Test38, Test39, Test40, Test41, Test42,
	     Test43],
    %% Maximum time per test
    Timeout = 400,
    Inst = fun(X) -> [{timeout, Timeout, {D, fun() -> T(X) end}} ||
			 {D, T} <- Tests] end,
    {foreach, local, Setup, Cleanup, [Inst]}.

test_ok(Target, PrebList) -> test_ok(Target, PrebList, ?TEST_ERL_PATH).

test_ok(Target, PrebList, TestPaths) ->
    Path = {files, TestPaths},
    Test = fun(Preb, Cnt) ->
		   Result = sched:analyze(Target, [Path, {preb, Preb}]),
		   ?assertEqual({ok, {Target, Cnt}}, Result)
	   end,
    [Test(Preb, Cnt) || {Preb, Cnt} <- PrebList].

test_error(Target, Error, PrebList) ->
    test_error(Target, Error, PrebList, ?TEST_ERL_PATH).

test_error(Target, Error, PrebList, TestPaths) ->
    Path = {files, TestPaths},
    Test = 
	fun(Preb, Cnt, TicketCnt) ->
		case TicketCnt of
		    0 -> test_ok(Target, [{Preb, Cnt}]);
		    _Other ->
			{error, analysis, {Target, Cnt}, Tickets} =
			    sched:analyze(Target, [Path, {preb, Preb}]),
			?assertEqual(TicketCnt, length(Tickets)),
			[?assertEqual(Error, error:type(ticket:get_error(T))) ||
			    T <- Tickets]
		end
	end,
    [Test(Preb, Cnt, TicketCnt) || {Preb, Cnt, TicketCnt} <- PrebList].
