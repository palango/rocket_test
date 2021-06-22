# -- Stage 1 -- #
# Compile the app.
FROM rust:latest as builder
WORKDIR /app
COPY . .
RUN cargo build --release
RUN ls target/release

# -- Stage 2 -- #
# Create the final environment with the compiled binary.
FROM debian:buster-slim
# Install any required dependencies.
RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from the builder stage and set it as the default command.
COPY --from=builder /app/target/release/hello-rocket /usr/local/bin/
RUN chmod +x /usr/local/bin/hello-rocket
RUN ls /usr/local/bin/
CMD ["hello-rocket"]
