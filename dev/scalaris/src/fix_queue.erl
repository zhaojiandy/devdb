%  @copyright 2009-2010 Konrad-Zuse-Zentrum fuer Informationstechnik Berlin

%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.

%% @author Christian Hennig <hennig@zib.de>
%% @doc    Queue implementation with a fixed maximum length.
%% @end
%% @version $Id: fix_queue.erl 906 2010-07-23 14:09:20Z schuett $
-module(fix_queue).
-author('hennig@zib.de').
-vsn('$Id: fix_queue.erl 906 2010-07-23 14:09:20Z schuett $').

-include("scalaris.hrl").

-ifdef(with_export_type_support).
-export_type([fix_queue/0]).
-endif.

-export([new/1, add/2, map/2]).

-type(fix_queue() :: {MaxLength :: pos_integer(),
                      Length    :: non_neg_integer(),
                      Queue     :: queue()}).

%% @doc Creates a new fixed-size queue.
-spec new(MaxLength :: pos_integer()) -> fix_queue().
new(MaxLength) ->
    {MaxLength, 0, queue:new()}.

%% @doc Adds an element to the given queue. 
-spec add(Element :: term(), Queue :: fix_queue()) -> fix_queue().
add(Elem, {MaxLength, Length, Queue}) ->
    {_, NewQueue} =
        case Length =:= MaxLength of
            true ->
                NewLength = Length,
                queue:out(queue:in(Elem, Queue));
            false ->
                NewLength = Length + 1,
                {foo, queue:in(Elem, Queue)}
        end,
    {MaxLength, NewLength, NewQueue}.

%% @doc Maps a function to all elements of the given queue.
-spec map(fun((term()) -> E), Queue :: fix_queue()) -> [E].
map(Fun, {_MaxLength, _Length, Queue}) ->
   lists:map(Fun, queue:to_list(Queue)).
