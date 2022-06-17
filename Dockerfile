FROM crystallang/crystal:1.4.1-alpine as crystal_malloc
RUN apk add --no-cache bash dpkg git
RUN apk add --no-cache autoconf automake make
RUN apk add --no-cache clang clang-dev gcc lld musl-dev g++
RUN ln -sf /usr/bin/clang /usr/bin/cc
RUN ln -sf /usr/bin/clang++ /usr/bin/c++
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang 10
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 10
RUN update-alternatives --install /usr/bin/ld ld /usr/bin/lld 10
RUN update-alternatives --auto cc
RUN update-alternatives --auto c++
RUN update-alternatives --auto ld
RUN update-alternatives --display cc
RUN update-alternatives --display c++
RUN update-alternatives --display ld
WORKDIR /tmp
RUN git clone https://github.com/emeryberger/Hoard
RUN cd Hoard/src && make

FROM crystallang/crystal:1.4.1-alpine as crystal_dependencies
ENV LUCKY_ENV=production
ENV SKIP_LUCKY_TASK_PRECOMPILATION=1
WORKDIR /shards
COPY shard.* ./
RUN  shards install --production

FROM node:alpine as asset_build
WORKDIR /assets
COPY . .
RUN yarn install
RUN yarn prod

FROM crystallang/crystal:1.4.1-alpine as lucky_tasks_build
ENV LUCKY_ENV=production
RUN apk --no-cache add yaml-static
COPY . .
COPY --from=crystal_dependencies /shards/lib lib
COPY --from=asset_build /assets/public public
RUN crystal build --static --release tasks.cr -o /usr/local/bin/lucky

FROM crystallang/crystal:1.4.1-alpine as lucky_webserver_build
WORKDIR /webserver_build
RUN apk --no-cache add yaml-static coreutils
ENV LUCKY_ENV=production
COPY . .
COPY --from=crystal_dependencies /shards/lib lib
COPY --from=asset_build /assets/public public
RUN shards build --production --static --release
RUN mv ./bin/app /usr/local/bin/webserver

FROM alpine as webserver
WORKDIR /app
RUN apk --no-cache add postgresql-client tzdata
COPY --from=lucky_tasks_build /usr/local/bin/lucky /usr/local/bin/lucky
COPY --from=lucky_webserver_build /usr/local/bin/webserver webserver
COPY --from=asset_build /assets/public public
COPY --from=crystal_malloc /tmp/Hoard /app/Hoard

ENV PORT 8080
ENV LD_PRELOAD /app/Hoard/libhoard.so
CMD ["./webserver"]