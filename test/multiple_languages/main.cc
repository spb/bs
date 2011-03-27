#include <iostream>

extern "C" void c_function(const char *message);

int main()
{
    std::cout << "In main function" << std::endl;
    c_function("Calling C function");
    return 0;
}
