# An environment where everything I usually use is already installed.

FROM ubuntu:24.04

RUN apt update && apt install -y software-properties-common build-essential
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update && apt install -y rake sudo tmux curl git neovim python3 ssh unzip ruby-dev python3-venv zlib1g-dev libffi-dev libssl-dev libyaml-dev
RUN curl -s -L https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz | tar -xz -C /usr/local
RUN useradd -m ctaylorr
USER ctaylorr
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ~/.cargo/bin/rustup default 1.77.2
RUN ~/.cargo/bin/cargo install --locked fd-find
USER root
RUN echo 'ctaylorr ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN mkdir -p /home/ctaylorr/src/github.com/cttttt/dotfiles/
COPY --chown=ctaylorr . /home/ctaylorr/src/github.com/cttttt/dotfiles/
# RUN chown -R ctaylorr /home/ctaylorr
USER ctaylorr
WORKDIR /home/ctaylorr
ENV GOPATH="/home/ctaylorr"
ENV PATH="/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

CMD [ "bash", "-c", "PATH=$PATH:~/.cargo/bin cd src/github.com/cttttt/dotfiles && rake && exec bash" ]
