#include "test_library.hh"

#ifndef __BUILD_TEST_LIBRARY__
#error Required preprocessor define __BUILD_TEST_LIBRARY__ not passed through.
#endif

#ifdef __BUILD_TEST_LIBRARY_2__
#error Preprocessor define __BUILD_TEST_LIBRARY_2__ incorrectly passed through.
#endif

std::string test_function()
{
    return "Hello, world.";
}
