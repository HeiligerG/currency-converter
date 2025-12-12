#!/bin/bash

tol=0.0000000001

run_test() {
    cmd="$1"
    expected="$2"
    actual=$(eval "$cmd")
    if [ "$expected" = "undefined" ]; then
        if [ "$actual" = "undefined" ]; then
            return 0
        else
            echo "FAIL: $cmd expected 'undefined', got '$actual'"
            return 1
        fi
    else
        # use awk for floating compare
        if echo "$actual" | awk -v e="$expected" -v t="$tol" 'BEGIN {diff=($0 - e); if (diff < 0) diff = -diff; exit (diff > t)}'; then
            echo "FAIL: $cmd expected $expected, got $actual"
            return 1
        else
            return 0
        fi
    fi
}

pass=0
fail=0

# Test 1: usd -> chf
if run_test "deno run --allow-read ../src/cli.ts --rates ../exchange-rates.json --from usd --to chf --amount 100" "81"; then
    ((pass++))
else
    ((fail++))
fi

# Test 2: eur -> chf
if run_test "deno run --allow-read ../src/cli.ts --rates ../exchange-rates.json --from eur --to chf --amount 200" "188"; then
    ((pass++))
else
    ((fail++))
fi

# Test 3: chf -> usd (reverse)
if run_test "deno run --allow-read ../src/cli.ts --rates ../exchange-rates.json --from chf --to usd --amount 100" "123.45679012345678"; then
    ((pass++))
else
    ((fail++))
fi

# Test 4: usd -> gbp (unbekannte währung)
if run_test "deno run --allow-read ../src/cli.ts --rates ../exchange-rates.json --from usd --to gbp --amount 100" "undefined"; then
    ((pass++))
else
    ((fail++))
fi

echo "Pass: $pass, Fail: $fail"
if [ $fail -eq 0 ]; then
    exit 0
else
    exit 1
fi
