# -- Stage 1 -- #
# Compile the app.
FROM rust:latest as builder
WORKDIR /app
COPY . .
RUN cargo build --release

# -- Stage 2 -- #
# Create the final environment with the compiled binary.
FROM debian:buster-slim
# Install any required dependencies.
RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from the builder stage and set it as the default command.
COPY --from=builder /app/target/release/hello-rocket /usr/local/bin/
# RUN chmod +x /usr/local/bin/hello-rocket
ENV ROCKET_PORT="8080"
ENV ROCKET_ADDRESS="0.0.0.0"
CMD ["hello-rocket"]
