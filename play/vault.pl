#!/usr/bin/env perl
#       play-2013.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib qw| lib |;
use Error::Base;
use Perl6::Form;
use Test::Trap;

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
use Test::More;

my $rv  = trap{
    pass('I passed wrongly.');      # should fail
    fail('I failed correctly.');    # should pass
    
#~     say '1..2';
#~     say 'ok 1 fake pass';
#~     say 'not ok 2 fake fail';
};



#~ say $trap->stdout;

pass('The kids are alright.');      # should pass anyway

done_testing;
exit(0);
#----------------------------------------------------------------------------#


#============================================================================#
__END__     
