package Mike;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
#~ use Alice 'run';
use Alice;

# All of these work just fine. 

#~ sub import {
#~     my $package = shift;
#~     Alice->import( { into_level => 1 }, @_ );
#~ };

#~ sub import {
#~     my $package = shift;
#~     Alice::import( __PACKAGE__, { into_level => 1 }, @_ );
#~ };

#~ sub import {
#~     my $package = shift;
#~     Alice::import( 'Mike', { into_level => 1 }, @_ );
#~ };

sub import {
    my $package = shift;
    Alice::import( 'Alice', { into_level => 1 }, @_ );
};


1;
