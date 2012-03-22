TESTS = test_pass test_needs_dso

test_pass_SOURCES = pass.cpp

test_needs_dso_SOURCES = dso.cpp
test_needs_dso_LIBRARIES = library/test
