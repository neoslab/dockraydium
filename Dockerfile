FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Setup Environment
RUN apt update && apt -y upgrade && apt -y dist-upgrade && \
    apt -y install build-essential curl git just \
    libclang-dev libssl-dev libudev-dev llvm protobuf-compiler \
    nano pkg-config sudo && \
    apt -y autoremove && apt -y clean && apt -y autoclean

# Install Rust 1.79.0
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=1.79.0
ENV PATH="/root/.cargo/bin:$PATH"

# Install Solana 1.17.34
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.17.34/install)" && \
    echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
ENV PATH="/root/.local/share/solana/install/active_release/bin:$PATH"

# Install Anchor v0.29.0 (no AVM)
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --tag v0.29.0 --locked

# Build Raydium
RUN git clone https://github.com/raydium-io/raydium-library /root/raydium && \
    cd /root/raydium && cargo build --release

CMD [ "bash" ]
