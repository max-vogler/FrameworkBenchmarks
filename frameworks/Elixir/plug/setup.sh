#!/bin/bash

fw_depends elixir

rm -rf _build deps rel

sed -i 's|localhost|'${DBHOST}'|g' config/config.exs

export MIX_ENV=prod
mix local.hex --force
mix local.rebar --force
mix deps.get --force --only prod
mix compile --force

elixir --erl "+K true" --detached  -pa _build/prod/consolidated -S mix
