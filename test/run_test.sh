#!/bin/bash

TEST_TEMP_DIR=test_run
TEST_BASELINE_DIR=test_baselines

run()
{
    local name=$1;
    shift;
    local cmd
    if [[ $# -gt 0 ]]; then
        cmd=("$@")
    else
        cmd="$name"
    fi

    mkdir -p "${TEST_TEMP_DIR}"
    TEST_OUT="${TEST_TEMP_DIR}/${name}.out"

    echo -n "Running '${cmd[@]}' ... "
    "${cmd[@]}" >"${TEST_OUT}"
    ret=$?

    if [[ $ret -eq 0 ]]; then
        echo "OK"
    else
        echo "failed"
        exit $ret
    fi
}

run_and_compare()
{
    local name=$1;
    shift;
    local cmd
    if [[ $# -gt 0 ]]; then
        cmd=("$@")
    else
        cmd="$name"
    fi

    mkdir -p "${TEST_TEMP_DIR}"
    TEST_OUT="${TEST_TEMP_DIR}/${name}.out"
    BASELINE_OUT="${TEST_BASELINE_DIR}/${name}.out"

    echo -n "Running '${cmd[@]}' ... "
    "${cmd[@]}" >"${TEST_OUT}"
    if diff -q "${TEST_OUT}" "${BASELINE_OUT}"; then
        echo "OK"
    else
        diff -u "${BASELINE_OUT}" "${TEST_OUT}"
        exit $?
    fi
}

cd $(dirname $0)
rm -rf build intermediate
run make
run_and_compare executable ./build/bin/executable


