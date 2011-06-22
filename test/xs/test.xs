#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>


void function();

MODULE = Test PACKAGE = Test

void
Function()
CODE:
    function();
