#include "lnl.hh"

#include <iostream>

void function_one()
{
    static_function();
    function_two();
    std::cout << "function one" << std::endl;
}
