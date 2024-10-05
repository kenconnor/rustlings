FROM ubuntu:latest AS build-env
RUN apt update \
 && apt install -y --no-install-recommends \
    curl \
    git \
    unzip \
    ca-certificates

# Download Nvim
RUN NVIM_VERSION=$(curl -sI https://github.com/neovim/neovim/releases/latest | grep -i location | awk -F '/' '{print $NF}' | tr -d '\r' | sed 's/^v//') \
 && curl -OL https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage
RUN chmod u+x nvim.appimage && ./nvim.appimage  --appimage-extract

# Download Clangd
RUN CLANGD_VERSION=$(curl -I https://github.com/clangd/clangd/releases/latest | grep -i location | awk -F '/' '{print $NF}' | tr -d '\r') \
 && curl -L -o clangd-linux-${CLANGD_VERSION}.zip https://github.com/clangd/clangd/releases/download/${CLANGD_VERSION}/clangd-linux-${CLANGD_VERSION}.zip \
 && mkdir -p /root/.config/coc/extensions/coc-clangd-data/install/${CLANGD_VERSION}/ \
 && unzip clangd-linux-${CLANGD_VERSION}.zip -d /root/.config/coc/extensions/coc-clangd-data/install/${CLANGD_VERSION}/

# Download Rust Analyzer
RUN RUST_ANALYZER_VERSION=$(curl -I https://github.com/rust-lang/rust-analyzer/releases/latest | grep -i location | awk -F '/' '{print $NF}' | tr -d '\r') \
 && curl -L -o rust-analyzer.gz https://github.com/rust-lang/rust-analyzer/releases/download/${RUST_ANALYZER_VERSION}/rust-analyzer-x86_64-unknown-linux-gnu.gz
RUN gzip -d rust-analyzer.gz && chmod +x rust-analyzer

FROM ubuntu:latest
COPY .config /root/.config
COPY --from=build-env /squashfs-root /root/nvim
COPY --from=build-env /root/.config/coc/extensions/coc-clangd-data/install /root/.config/coc/extensions/coc-clangd-data/install
COPY --from=build-env /rust-analyzer /root/.config/coc/extensions/coc-rust-analyzer-data/rust-analyzer
RUN ln -s /root/nvim/AppRun /usr/bin/nvim

RUN apt update && apt install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    build-essential \
    locales \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN curl -sL install-node.vercel.app/lts | bash -s -- -y
RUN mkdir -p /root/.local/share
RUN nvim +'CocInstall -sync coc-pyright' +qall
RUN nvim +'CocInstall -sync coc-clangd' +qall
RUN nvim +'CocInstall -sync coc-rust-analyzer' +qall

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN PATH="$HOME/.cargo/bin:$PATH" \
 && cargo install rustlings \
 && rustlings init \
 && rustup component add clippy
