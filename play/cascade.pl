#!/usr/bin/env perl
#       cascade.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

# Core modules
use lib 'lib';

# CPAN modules
#~ use Error::Base;                # Simple structured errors with full backtrace

# Project module
use Devel::Toolbox::Core::Config::Cascade;

# Alternate uses
use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

my @paths   = qw( play . zaamm );
my @stems   = qw( config confoozly );
my $flip    = 1;
my $merge   = 0;
my $stop    = 1;
my $status  = {};
my $config  = {};
#~ say 'main-before: ', $config;                               # DEBUG ONLY ~#


my $returned  = Devel::Toolbox::Core::Config::Cascade->get({
    -paths      => \@paths,     # filesystem paths to search
    -stems      => \@stems,     # filename stems to search
#~     -priority   => $literal,    # 'LEFT', 'RIGHT', 'STORAGE', 'RETAINMENT'
#~     -flip       => $flip,       # invert cross-join matrix
#~     -merge      => $merge,      # discard filename keys
#~     -stop       => $stop,       # stop after so many files
    -status     => \$status,     # RETURNS status results
    -config     => \$config,     # RETURNS configuration (merged)
});
#~ say 'main-after: ', $config;                                # DEBUG ONLY ~#
### main script:
### $status
#~ ### $config
### $returned



exit 0;
__END__     
