
Build exa static binary (by musl):

    git clone https://github.com/ogham/exa.git
    docker run -v $PWD:/volume -w /volume -it --rm clux/muslrust bash

    # Inside Docker
    apt-get update
    apt-get install cmake
    make target/release/exa
    mkdir release_linux_musl
    install -m755 target/x86_64-unknown-linux-musl/release/exa release_linux_musl/
    install -m644 contrib/completions.fish release_linux_musl/
    install -m644 contrib/man/exa.1 release_linux_musl/
