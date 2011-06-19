#!/usr/bin/perl

use Getopt::Long;

my ($input_fn, $output_fn, $mode);

GetOptions('i=s' => \$input_fn,
           'o=s' => \$output_fn,
           'm=s' => \$mode,
);

open my $in, '<', $input_fn or die "Couldn't open $input_fn for reading: $!";
open my $out, '>', $output_fn or die "Couldn't open $output_fn for writing: $!";

print $out <<EOH;
#include <string>

EOH

while (<$in>) {
    chomp;
    if (/(.*)=(.*)/) {
        my ($function_name, $return_string) = ($1, $2);
        print "fn=$function_name rs=$return_string\n";
        if ($mode eq 'header') {
            print $out "std::string $function_name();\n";
        } else {
            print "goats\n";
            print $out "std::string $function_name() { return \"$return_string\"; }\n";
        }
    }
}


close $in;
close $out;
