# An environment where everything I usually use is already installed.

FROM ubuntu:18.04

RUN apt update && apt install -y software-properties-common
RUN add-apt-repository -y ppa:neovim-ppa/stable
RUN apt-get update && apt install -y rake sudo tmux curl git neovim cargo python ssh
RUN useradd -m ctaylorr
USER ctaylorr
RUN cargo install fd-find
USER root
RUN echo 'ctaylorr ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN mkdir -p /home/ctaylorr/src/github.com/cttttt/dotfiles/
COPY . /home/ctaylorr/src/github.com/cttttt/dotfiles/
RUN chown -R ctaylorr /home/ctaylorr
USER ctaylorr
WORKDIR /home/ctaylorr

CMD [ "bash", "-c", "cd src/github.com/cttttt/dotfiles && rake && exec bash" ]
