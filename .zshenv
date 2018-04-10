# Node.js Config
## NVM
[ -d "$HOME/.nvm" ]      && export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

## NPM Registry
[ -f $HOME/.npmrc ] && 
	export NPM_TOKEN=$(cat $HOME/.npmrc|grep npm.famoco.com/repository/npm-all|egrep -o "authToken=(.+)" | cut -d= -f2)

# Rust
[ -d "$HOME/.cargo/bin:$PATH" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$(rustc --print sysroot)/lib/rustlib/src/rust/src" ] && export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

