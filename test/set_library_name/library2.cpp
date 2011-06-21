#include <iostream>

extern "C" void set_filename_function()
{
    std::cout << "This is also not a hello world" << std::endl;
}
