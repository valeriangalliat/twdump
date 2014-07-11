#!/bin/sh -e
#
# Cron job to dump tweets in an ordered file.
#
# Each time it is called, the tweets newer than the last tweet from the
# file are retrieved and sorted, then appended to the main file.
#

readonly PROGDIR=$(dirname "$0")

#
# $1: File
#
last_tweet_id() {
    tail -1 "$1" | "$PROGDIR/twdump-list" -k id | cut -d: -f1
}

#
# $1: File to dump tweets in
# $@: Arguments proxied to `twdump`
#
main() {
    file="$1"; shift
    id=$(last_tweet_id "$file")

    "$PROGDIR/twdump" -s "$id" "$@" | "$PROGDIR/twdump-sort" >> "$file"
}

main "$@"
