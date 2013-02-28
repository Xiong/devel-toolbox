package Foo;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
use Error::Base;

#~ use Devel::Comments '###';                                               #~

use Devel::Toolbox;             # Simple custom project tool management

my $U   = get_global_pool();
say '[Foo] $U: ', $U;

sub peepee {
    my $fake    = $U->{-sub}{plurky};
    my $fart    = $U->{-sub}{fiddle};
say '[Foo::peepee] $U: ', $U;
    &$fake();
    &$fart();
};

1;
