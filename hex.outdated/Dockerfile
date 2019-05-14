FROM elixir:1.8.1-alpine

LABEL "repository"="https://github.com/jclem/action-mix"
LABEL "homepage"="https://github.com/jclem/action-mix"
LABEL "maintainer"="Jonathan Clem <jonathan@jclem.net>"

LABEL "com.github.actions.name"="Run `mix hex.outdated and comment on PR`"
LABEL "com.github.actions.description"="An action for running `mix hex.outdated`"
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="orange"

RUN apk add --no-cache \
  bash \
  ca-certificates \
  coreutils \
  curl \
  git \
  jq

ARG MIX_HOME=/.mix
ENV MIX_HOME=$MIX_HOME
ARG MIX_ENV=dev
ENV MIX_ENV=$MIX_ENV

RUN mix local.rebar --force
RUN mix local.hex --force

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
