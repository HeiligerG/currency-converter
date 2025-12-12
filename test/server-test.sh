#!/bin/bash

# konfiguration
tol=0.0000000001
port=8000
base_url="http://localhost:$port"
auth="banker:iLikeMoney"

compare_float() {
    local actual=$1
    local expected=$2
    if echo "$actual" | awk -v e="$expected" -v t="$tol" 'BEGIN {diff=($0 - e); if (diff < 0) diff = -diff; exit (diff > t)}'; then
        return 1
    else
        return 0
    fi
}