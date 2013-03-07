#!/usr/bin/env perl
#  config.pl
#  =  Copyright 2013 Xiong Changnian <xiong@cpan.org>   =
#  = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

# Core modules
use lib 'lib';

# Project modules
use Devel::Toolbox::Core::Config;

say "$0 running...";
my $rc  = Devel::Toolbox::Core::Config::load_files();
say "Done.";
exit 0;

#----------------------------------------------------------------------------#

__DATA__
foo
bar
