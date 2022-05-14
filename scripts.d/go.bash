if [ -n $SRC/go ]; then
    export GOPATH=$SRC/go
    export PATH=$GOPATH/bin:$PATH
fi
