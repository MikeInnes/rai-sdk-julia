# Copyright 2022 RelationalAI, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# Delete an engine.

using RAI: Context, HTTPError, load_config, delete_engine, get_engine

include("parseargs.jl")

# Answers if the given value represents a terminal state.
is_term_state(state) = state == "DELETED" || occursin("FAILED", state)

function run(engine; profile)
    conf = load_config(; profile = profile)
    ctx = Context(conf)
    rsp = delete_engine(ctx, engine)
    while !is_term_state(get(rsp, "state", ""))  # wait for terminal state
        sleep(3)
        rsp = get_engine(ctx, engine)
    end
    println(rsp)
end

function main()
    args = parseargs(
        "engine", Dict(:help => "engine name", :required => true),
        "--profile", Dict(:help => "config profile (default: default)"))
    try
        run(args["engine"]; profile = args["profile"])
    catch e
        e isa HTTPError ? show(e) : rethrow(e)
    end
end

main()
