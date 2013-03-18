#!/usr/bin/env perl
#  config-it.pl
#  =  Copyright 2013 Xiong Changnian <xiong@cpan.org>   =
#  = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

# Core modules
use lib 'lib';

# Project modules
# Define pool first! 
BEGIN {                         #    $::U or $main::U
    $::U      = {};             # package variable escapes BEGIN block
#~ say 'dt-BEGIN: ', $::U;                                      DEBUG ONLY  #~
    # Make get_global_pool work now.
    use Devel::Toolbox::Core::Pool qw( -main );
    init_global_pool($::U);
}
use Devel::Toolbox::Core::Config;

use Devel::Comments '###';                                               #~
#============================================================================#
our $U;

say "$0 running...";
my $u   = { hoge => 'piyo' };
merge_global_pool($u);
my $rc  = Devel::Toolbox::Core::Config::load_config_files();
### $U
say "$0 Done.";
exit 0;

#----------------------------------------------------------------------------#
__END__
