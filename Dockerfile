# Targets:
#   docker build --target sda-no-db -t <registry>/sda-no-db:<version> .
#   docker build --target sda       -t <registry>/sda:<version> .   (default, includes Memgraph)

# Build stage
FROM ghcr.io/descartesresearch/fishnet-deps:1.2.0 AS build
COPY . /sda-workflow
WORKDIR /sda-workflow/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DSDA_TEST=OFF ..
RUN cmake --build . --config Release -j 8
RUN cmake --install .

# Runtime stage without database
FROM ghcr.io/osgeo/gdal:ubuntu-small-3.9.3 AS sda-no-db
ARG VERSION=dev
ARG REVISION=unknown
# overrides the labels inherited from the gdal base image
LABEL org.opencontainers.image.source="https://github.com/dfg-sos/sda-workflow" \
      org.opencontainers.image.url="https://github.com/dfg-sos/sda-workflow" \
      org.opencontainers.image.title="sda-workflow" \
      org.opencontainers.image.description="Settlement Delineation and Analysis (SDA) workflow" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.licenses="MIT"
RUN apt-get update && apt-get install -y cwltool && apt-get clean
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /sda-workflow/cwl/ /cwl
RUN mkdir -p /data/working
WORKDIR /data/working

# Runtime stage with Memgraph
FROM sda-no-db AS sda
ARG MEMGRAPH_VERSION=3.1.1
RUN apt-get update && apt-get install -y wget adduser && apt-get clean
WORKDIR /tmp
RUN wget -O memgraph.deb https://download.memgraph.com/memgraph/v${MEMGRAPH_VERSION}/ubuntu-24.04/memgraph_${MEMGRAPH_VERSION}-1_amd64.deb \
    && dpkg -i memgraph.deb \
    && rm memgraph.deb
WORKDIR /data/working
CMD [ "su", "memgraph" , "-c", "/usr/lib/memgraph/memgraph --query-execution-timeout-sec=0 --storage-mode=IN_MEMORY_ANALYTICAL" ]
