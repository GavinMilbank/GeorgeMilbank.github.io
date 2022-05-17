#!/usr/bin/perl
use strict;
use warnings;
for my $old (@ARGV){
    my $new;
    $new = $old;
    $new =~ s/\s+/-/og;
    print("$old => $new\n");
    rename($old, $new) unless $new eq $old;
}

