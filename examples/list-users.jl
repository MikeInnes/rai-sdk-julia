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

# List all users.

using RAI: Context, HTTPError, load_config, list_users

include("parseargs.jl")

function run(; profile)
    conf = load_config(; profile = profile)
    ctx = Context(conf)
    rsp = list_users(ctx)
    println(rsp)
end

function main()
    args = parseargs("--profile", Dict(:help => "config profile (default: default)"))
    try
        run(; profile = args.profile)
    catch e
        e isa HTTPError ? show(e) : rethrow(e)
    end
end

main()
