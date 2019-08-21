FROM bitwalker/alpine-elixir:1.9.1
FROM elixir:1.9.1-alpine

# Look into distillery
# Set exposed ports
EXPOSE 5000
ENV PORT=5000

ENV MIX_ENV=prod

COPY yourapp.tar.gz ./
RUN tar -xzvf yourapp.tar.gz

USER default

CMD ./bin/yourapp foreground
