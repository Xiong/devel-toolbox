#!/usr/bin/env perl
#  slurp-data.pl
#  =  Copyright 2013 Xiong Changnian <xiong@cpan.org>   =
#  = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

# Core modules
use lib 'play';

# Project modules
use SlurpData;

say "$0 running...";
say SlurpData::get();
say "Done.";
exit 0;

#----------------------------------------------------------------------------#

__DATA__
foo
bar
