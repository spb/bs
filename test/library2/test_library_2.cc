#include "test_library_2.hh"

#ifndef __BUILD_TEST_LIBRARY_2__
#error Required preprocessor define __BUILD_TEST_LIBRARY_2__ not passed through.
#endif

#ifdef __BUILD_TEST_LIBRARY__
#error Preprocessor define __BUILD_TEST_LIBRARY__ incorrectly passed through.
#endif

std::string test_function_2()
{
    return "Goodbye, world.";
}
