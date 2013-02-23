#!/usr/bin/env perl
use strict;
use warnings;

my $self    = Foo::Bar->new;
my $rc      = $self->Widget::Thing::wobble;
print "$rc\n";

package Widget::Thing;
sub wobble { 42 };

package Foo::Bar;
sub new { bless {}, shift };
sub wobble { 13 };
                                # prints 42
