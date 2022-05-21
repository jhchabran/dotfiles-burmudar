if [ -n $SRC/go ]; then
    export GOPATH=$SRC/go
    export GOBIN=$HOME/bin
    export PATH=$GOPATH/bin:$PATH
fi
