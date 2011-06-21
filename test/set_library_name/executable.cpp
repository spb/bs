#include <iostream>
#include <cstdlib>
#include <dlfcn.h>

void set_library_name_function();

int main()
{
    set_library_name_function();

    // No real error checking; segfaulting will fail the test just fine
    void *library = dlopen("build/lib/testfilename.so", RTLD_LOCAL | RTLD_NOW);
    if (!library)
    {
        std::cerr << "Couldn't open build/lib/testfilename.so" << std::endl;
        std::exit(1);
    }
    void *symbol = dlsym(library, "set_filename_function");
    void (*function)() = reinterpret_cast<void(*)()>(symbol);
    function();
}

