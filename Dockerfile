FROM postgres:16.2 as build

WORKDIR /tmp/src

RUN apt-get update && \
    apt-get install -y git build-essential python3 postgresql-server-dev-16 libgmp3-dev

RUN git clone https://github.com/dvarrazzo/pgmp.git && \
    cd pgmp && make && make install

FROM postgres:16

COPY --from=0 /usr/lib/postgresql/16/lib/pgmp.so /usr/lib/postgresql/16/lib/pgmp.so
COPY --from=0 /usr/share/postgresql/16/extension/pgmp.control /usr/share/postgresql/16/extension/pgmp.control
COPY --from=0 /usr/share/postgresql/16/pgmp /usr/share/postgresql/16/pgmp
COPY --from=0 /usr/lib/postgresql/16/lib/bitcode/pgmp /usr/lib/postgresql/16/lib/bitcode/pgmp
