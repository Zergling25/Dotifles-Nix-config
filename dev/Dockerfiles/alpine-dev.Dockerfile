# Use Alpine as the base image
FROM alpine:latest

# Set the working directory to /root
WORKDIR /root

# Update + Install necessary packages
Run apk update && apk upgrade

RUN apk add --no-cache git neovim ripgrep build-base wget python3 gdb clang clang-dev

# Clone the Nvim configuration repository into the appropriate directory
RUN rm -rf ~/.config/nvim
RUN git clone https://github.com/Zergling25/Standard-Nvim-Config ~/.config/nvim

# Set the entrypoint to open Neovim when the container starts
# ENTRYPOINT ["nvim"]

