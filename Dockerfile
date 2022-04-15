FROM elixir:1.13.4

WORKDIR /code

COPY ["entrypoint", "/entrypoint"]

ENTRYPOINT ["/entrypoint"]
