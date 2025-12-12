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


# big ass funktion zum runnen von testcases
run_test() {
    local description="$1"
    local method="$2"
    local url="$3"
    local data="$4"
    local expected_status="$5"
    local expected_json="$6"
    local auth_param="$7"
    
    local curl_cmd="curl -s -X $method"
    if [ -n "$auth_param" ]; then
        curl_cmd="$curl_cmd -u $auth_param"
    fi
    if [ -n "$data" ]; then
        curl_cmd="$curl_cmd -d '$data' -H 'Content-Type: application/json'"
    fi
    curl_cmd="$curl_cmd -w '%{http_code}' $url"
    
    local output
    output=$(eval "$curl_cmd" 2>/dev/null)
    local status=${output: -3}
    local body=${output%???}
    
    if [ "$status" != "$expected_status" ]; then
        echo "FAIL: $description - Status $status erwartet $expected_status"
        return 1
    fi
    
    if [ -n "$expected_json" ]; then
        local rate=$(echo "$body" | jq -r '.rate // .result // empty')
        if [ -n "$rate" ]; then
            if ! compare_float "$rate" "$expected_json"; then
                echo "FAIL: $description - Wert $rate erwartet $expected_json"
                return 1
            fi
        else
            local expected_body=$(echo "$expected_json" | jq -c .)
            if [ "$body" != "$expected_body" ]; then
                echo "FAIL: $description - JSON nicht gleich"
                return 1
            fi
        fi
    fi
    return 0
}

# main
start_server
pass=0
fail=0

# Test 1: PUT /rate/usd/eur/0.85
if run_test "PUT rate" "PUT" "$base_url/rate/usd/eur/0.85" "" "201" "" "$auth"; then
    ((pass++))
else
    ((fail++))
fi

stop_server
echo "Pass: $pass, Fail: $fail"
[ $fail -eq 0 ]