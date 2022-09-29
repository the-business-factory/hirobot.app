FROM robcole/crystal:lucky as common-crystal
ENV LUCKY_ENV=production
ENV SKIP_LUCKY_TASK_PRECOMPILATION=1

FROM common-crystal as shards
WORKDIR /shards
COPY shard.* ./
RUN shards install --production

FROM node:alpine as asset_build
WORKDIR /assets
COPY . .
RUN yarn install
RUN yarn prod

FROM common-crystal as lucky_tasks_build
ENV LUCKY_ENV=production
COPY . .
COPY --from=shards /shards/lib lib
COPY --from=asset_build /assets/public public
RUN crystal build --static --release tasks.cr -o /usr/local/bin/lucky

FROM common-crystal as lucky_webserver_build
WORKDIR /webserver_build
RUN 
ENV LUCKY_ENV=production
COPY . .
COPY --from=shards /shards/lib lib
COPY --from=asset_build /assets/public public
RUN shards build --production --static --release
RUN mv ./bin/app /usr/local/bin/webserver

FROM alpine as webserver
WORKDIR /app
RUN apk --no-cache add postgresql-client tzdata openssl openssl-dev openssl-libs-static
COPY --from=lucky_tasks_build /usr/local/bin/lucky /usr/local/bin/lucky
COPY --from=lucky_webserver_build /usr/local/bin/webserver webserver
COPY --from=asset_build /assets/public public
COPY --from=common-crystal /usr/local/Hoard /usr/local/Hoard

ENV LD_PRELOAD /usr/local/Hoard/libhoard.so
ENV PORT 8080
CMD ["./webserver"]
