#include "library/test_library.hh"
#include <iostream>

int main()
{
    std::cout << "Running test that needs a library" << std::endl;
    if (test_function() != "Hello, world.")
    {
        std::cerr << "test_function didn't return as expected" << std::endl;
        return 1;
    }
    return 0;
}


