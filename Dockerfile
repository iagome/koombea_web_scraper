FROM elixir:1.16 AS build

RUN mix do local.hex --force, local.rebar --force

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

RUN mix do deps.get, deps.compile

COPY . ./
RUN mix do compile --warnings-as-errors, release

# start application
CMD ["mix", "phx.server"
