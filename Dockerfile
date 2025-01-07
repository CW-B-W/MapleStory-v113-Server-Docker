FROM gradle:8.11.1-jdk8 AS builder

WORKDIR /app

COPY ./src /app/src
COPY ./dist /app/dist
COPY ./build.gradle /app/build.gradle

RUN gradle buildAndCopy

# ================================

FROM openjdk:8-jdk-slim

WORKDIR /app

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/dist/lib /app/dist/lib

# Install MySQL client
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt/lists/*

EXPOSE 8484
EXPOSE 8585
EXPOSE 8586
EXPOSE 8587

# start_tms_server.sh will be later replaced by mounted file
COPY start_tms_server.sh /app/start_tms_server.sh
RUN chmod +x /app/start_tms_server.sh
ENTRYPOINT ["/app/start_tms_server.sh"]
