if [ -n $SRC/go ]; then
    export GOPATH=$SRC/go
    export GOBIN=$SRC/bin
    export PATH=$GOPATH/bin:$PATH
fi
