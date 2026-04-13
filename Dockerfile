FROM fedora:42
WORKDIR /refinator

# Install dependencies
RUN dnf install -y zlib-ng-compat zlib-ng-compat-devel clang17 clang17-devel \
    llvm17 llvm17-devel z3 z3-devel rustup; dnf clean all
RUN rustup-init -y --profile minimal
ENV PATH=/root/.cargo/bin:$PATH

# Copy &inator source
ADD src src
ADD Cargo.* .

# Build and install &inator
RUN cargo install --path .; cargo clean

# Mount benchmarks
VOLUME ["/refinator/benchmarks"]

# Run the &inator executable on `docker run`
ENTRYPOINT ["refinator"]
