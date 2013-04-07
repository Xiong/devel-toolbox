#!/usr/bin/env perl
#       fennec.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib qw| lib play |;
use Error::Base;
use Perl6::Form;
use Fennec;                     # Next-generation test fixture

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
#~ say "$0 Running...";

{
    package Acme::Teddy;
    sub roar        { return        'Roar!'             };
}


tests roar => sub {
    my $have    = Acme::Teddy::roar();
    my $want    = 'Roar!';
    my $name    = 'return';
    ok( $have eq $want, $name );
};


#~ say "Done.";
exit;
#----------------------------------------------------------------------------#


#============================================================================#
__END__     
