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
    if diff -w -q "${TEST_OUT}" "${BASELINE_OUT}"; then
        echo "OK"
    else
        diff -w -u "${BASELINE_OUT}" "${TEST_OUT}"
        exit $?
    fi
}

assert()
{
    echo -n "Checking $@ ... "
    if eval "$@"; then
        echo "OK"
    else
        echo "failed"
        exit 1
    fi
}

cd $(dirname $0)
rm -rf build intermediate

export LD_LIBRARY_PATH=build/lib:$LD_LIBRARY_PATH

run make
run_and_compare executable ./build/bin/executable
run_and_compare executable2 ./build/bin/executable2
run_and_compare multiple_languages ./build/bin/multi_language
run_and_compare source_subdirs ./build/bin/source_subdirs

run_and_compare test_libname ./build/bin/test_libname
# Above will probably still run even if the library name setting failed,
# due to magic -l setting
assert [[ -f build/lib/libtestlibname.so ]]
assert [[ -f build/lib/testfilename.so ]]

# Check perl extension built
run_and_compare test_xs_extension perl -Ibuild/lib build/bin/test.pl

# Check partial rebuilds
echo "Checking partial builds: updating library/test_library.hh"
touch library/test_library.hh
run_and_compare partial_rebuild make

echo "All OK"
