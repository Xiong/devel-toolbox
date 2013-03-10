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

my @paths   = qw( . play zaamm );


my $returned  = Devel::Toolbox::Core::Config::Cascade->get({
    -paths  => \@paths,     # filesystem paths to search    # q{.}
#~     -stems  => \@stems,     # filename stems to search      # q{config}
#~     -flip   => $bool,       # invert cross-join matrix      # undef
#~     -merge  => $unsnd_int,  # level of flattening           # 1
#~     -stop   => $unsnd_int,  # stop after so many files      # undef
#~     -status => $hashref,    # RETURNS status results        writable
#~     -config => $hashref,    # RETURNS configuration         writable
});

### main script:
### $returned




exit 0;
__END__     
