# STAGE 1: Compilation
FROM debian:bookworm-slim AS builder

# Install tools required for building
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl git fpc ca-certificates unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Boss package manager
RUN curl -sSL https://github.com/HashLoad/boss/releases/latest/download/boss-linux-amd64.zip -o boss.zip \
    && unzip boss.zip -d /usr/local/bin \
    && mv /usr/local/bin/linux-amd64/boss /usr/local/bin/boss \
    && chmod +x /usr/local/bin/boss \
    && rm -rf /usr/local/bin/linux-amd64 boss.zip

WORKDIR /app
COPY . .

# Ensure machine-id to avoid boss runtime errors
RUN test -f /etc/machine-id || echo "00000000-0000-0000-0000-000000000000" > /etc/machine-id

# Install project dependencies (including Horse)
RUN boss install

# Compile the project
RUN mkdir -p build
RUN fpc -O3 \
    -Fu"modules/.bin" \
    -Fu"modules/horse/src" \
    -Fu"modules/horse-cors/src" \
    -FE"build" \
    JoistAPI.dpr
    
# STAGE 2: Runtime
FROM debian:bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/build/JoistAPI .

# Expose the port Horse is listening on
EXPOSE 9000

# Run the API
CMD ["./JoistAPI"]