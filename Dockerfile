FROM rust:latest
RUN apt update && apt install -y --no-install-recommends \
    vim-gtk3 \
    git \
    universal-ctags \
 && rm -rf /var/lib/apt/lists/*
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN echo "call plug#begin()"        >> /root/.vimrc \
 && echo "Plug 'tpope/vim-fugitive'" >> /root/.vimrc \
 && echo "call plug#end()"          >> /root/.vimrc
RUN vim +'PlugInstall --sync' +qa
RUN cargo install rustlings \
 && rustlings init
RUN rustup component add clippy
