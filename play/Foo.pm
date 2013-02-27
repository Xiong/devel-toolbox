package Foo;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
use Error::Base;

#~ use Devel::Comments '###';                                               #~

use Declare;

my $U   = Declare::get_global_store();
say '[Foo] $U: ', $U;

sub peepee {
#~     &{ $U->{plurky} }();
    my $fake    = $U->{plurky};
    my $fart    = $U->{fiddle};
say '[Foo::peepee] $U: ', $U;
    &$fake();
    &$fart();
};

1;
