#!/bin/bash

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

start_server() {
    deno run --allow-net src/server.ts &
    server_pid=$!
    for i in {1..10}; do
        if curl -s "$base_url/" > /dev/null 2>&1; then
            return 0
        fi
        sleep 0.5
    done
    echo "Server start fehlgeschlagen"
    exit 1
}

# Später komen hier die Testfälle.

stop_server() {
    kill $server_pid 2>/dev/null
    wait $server_pid 2>/dev/null
}