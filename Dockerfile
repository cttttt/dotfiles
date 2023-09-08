# An environment where everything I usually use is already installed.

FROM ubuntu:22.04

RUN apt update && apt install -y software-properties-common build-essential
RUN add-apt-repository -y ppa:neovim-ppa/stable
RUN apt-get update && apt install -y rake sudo tmux curl git neovim cargo python3 ssh unzip ruby-dev
RUN curl -s -L https://dl.google.com/go/go1.20.5.linux-amd64.tar.gz | tar -xz -C /usr/local
RUN useradd -m ctaylorr
USER ctaylorr
RUN cargo install --locked fd-find
USER root
RUN echo 'ctaylorr ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN mkdir -p /home/ctaylorr/src/github.com/cttttt/dotfiles/
COPY . /home/ctaylorr/src/github.com/cttttt/dotfiles/
RUN chown -R ctaylorr /home/ctaylorr
USER ctaylorr
WORKDIR /home/ctaylorr
ENV GOPATH="/home/ctaylorr"
ENV PATH="/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

CMD [ "bash", "-c", "cd src/github.com/cttttt/dotfiles && rake && exec bash" ]
