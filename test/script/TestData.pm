package TestData;

use TestData::TestTwo;

sub function {
    my ($arg) = @_;

    TestData::TestTwo::function($arg);
}

1;
