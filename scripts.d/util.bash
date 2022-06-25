collate() {
    DST="all.bash"
    for f in $(ls); do
        cat<<EOF >> $DST
# BEGIN $f
$(cat $f)
# END $f
EOF
    done
}
