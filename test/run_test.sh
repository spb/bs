#!/bin/bash

TEST_TEMP_DIR=test_run
TEST_BASELINE_DIR=test_baselines

if [[ $(uname) == CYGWIN* ]]; then
    dsodir=bin
    dsoext=dll
    PLATFORM=cygwin
else
    dsodir=lib
    dsoext=so
    PLATFORM=linux
fi

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

    BASELINE_OUT="${TEST_BASELINE_DIR}/${PLATFORM}/${name}.out"
    [[ -f ${BASELINE_OUT} ]] || BASELINE_OUT="${TEST_BASELINE_DIR}/${name}.out"

    echo -n "Running '${cmd[@]}' ... "
    if ! "${cmd[@]}" >"${TEST_OUT}"; then
        echo "failed"
        exit 1
    elif diff -w -q "${TEST_OUT}" "${BASELINE_OUT}"; then
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
run_and_compare executable_ending_+ ./build/bin/executable_ending_+
run_and_compare multiple_languages ./build/bin/multi_language
run_and_compare source_subdirs ./build/bin/source_subdirs

run_and_compare test_libname ./build/bin/test_libname
# Above will probably still run even if the library name setting failed,
# due to magic -l setting
assert [[ -f build/$dsodir/libtestlibname.$dsoext ]]
assert [[ -f build/lib/testfilename.so ]]

# Check perl extension built
run_and_compare test_xs_extension perl -Ibuild/lib build/bin/test.pl

run deptestexecutable ./build/bin/deptestexecutable
run test_script ./build/bin/test_script.sh
run_and_compare test_script_pl ./build/bin/test_script.pl

assert [[ -d build/empty_dir_1 ]]
assert [[ -d build/empty/dir/2 ]]

run_and_compare libraries_needing_libraries ./build/bin/lnl

# Check partial rebuilds
# Header file to check that object -> header dependencies are generated correctly, and
# source file to make sure that executables aren't relinked just because a shared library changed
echo "Checking partial builds: updating files"
touch library/test_library.hh
touch library_file_dependencies/library/library.cpp
touch script/TestData/TestTwo.pm
run_and_compare partial_rebuild make

# If this runs too fast, the touch below might just end up putting the same timestamp as the output file created above
sleep 1

echo "Checking relink after static library update, but not dynamic"
touch library/test_library.cc
touch library2/test_library_2.cc
run_and_compare library_relink make

# As above
sleep 1

echo "Checking rebuild after makefile change"
touch executable/build.mk
run_and_compare rebuild_makefile_change make

#
# Start over with a prefix defined
#
rm -rf build intermediate

export LD_LIBRARY_PATH=build/usr/lib:$LD_LIBRARY_PATH

run make_prefix make -f Makefile.prefix
run_and_compare executable_prefix ./build/usr/bin/executable

#
# And run some tests
#
rm -rf build intermediate

run_and_compare make_tests make -f Makefile.tests

rm -rf build intermediate
echo -n "Running 'make -f Makefile.failingtest' ... "
make -f Makefile.failingtest &>test_run/failing_tests.out
ret=$?
if [[ $ret == 0 ]]; then
    echo "succeeded, where it should have failed"
    exit 1
elif diff -w -q test_baselines/${PLATFORM}/failing_tests.out test_run/failing_tests.out; then
    echo "OK"
else
    diff -w -u test_baselines/${PLATFORM}/failing_tests.out test_run/failing_tests.out
    exit 1
fi


echo "All OK"
