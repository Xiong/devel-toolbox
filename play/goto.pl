#!/usr/bin/env perl
#       goto.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use Error::Base;

package Him;
sub him {
    my $err     = Error::Base->new();
    $err->crank();
};

package Us;
sub me  { goto &{ 'Him::him' } };
sub you { Him::him() };

package main;
Us::me();
Us::you();
    
__END__

# Emits: 
Undefined error.
in Him::him at line 15    [play/goto.pl]
___________ at line 23    [play/goto.pl]
Undefined error.
in Him::him at line 15    [play/goto.pl]
in Us::you  at line 20    [play/goto.pl]
___________ at line 24    [play/goto.pl]
