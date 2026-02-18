# STAGE 1: Compilation
FROM debian:bookworm-slim AS builder

# Install tools and Free Pascal compiler
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl git fpc \
    && rm -rf /var/lib/apt/lists/*

# Install Boss package manager
RUN curl -L https://github.com/HashLoad/boss/releases/latest/download/boss-linux-x86_64 -o /usr/local/bin/boss \
    && chmod +x /usr/local/bin/boss

WORKDIR /app
COPY . .

# Install dependencies and compile
RUN boss install
# Replace 'JoistAPI.dpr' with your actual project file name
RUN fpc -O3 -Fu./modules/.bin -FE./build JoistAPI.dpr

# STAGE 2: Runtime
FROM debian:bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy only the compiled binary from the builder stage
COPY --from=builder /app/build/JoistAPI .

# Expose the port Horse is listening on
EXPOSE 9000

# Run the API
CMD ["./JoistAPI"]