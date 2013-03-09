package Devel::Toolbox::Core::Config::Primary;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
#~ use lib 'lib';
#~ use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
#~ use Class::Inspector;           # Get info about a class and its structure
#~ use Sub::Exporter -setup => {   # Sophisticated custom exporter
#~     exports     => [ qw( declare ) ],
#~     groups      => { default => [ qw( declare ) ] },
#~ };

# Project modules
#~ use Devel::Toolbox;             # Simple custom project tool management
#~ use Devel::Toolbox::Core::Pool; # Global data pool IMPORTANT HERE!

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals
my $err     = Error::Base->new(
    -base   => '! DTC-Config-Primary:',
    _close  => 'Failed to close DATA after reading.',
);
#~ our $U      = get_global_pool();            # common to all toolsets

## pseudo-globals
#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~     $paths  = get_paths();     # get primary config paths
#
#   
#   
sub get_paths {
    my $paths       ;
    @$paths         = <DATA>;
    close DATA 
        or $err->crash ( $err->{ _close } );
    
    # Filter out comments and similar rubbish.
    chomp @$paths;
    my $qr_comment  = qr/^\s*#/;
    my $qr_empty    = qr/^\s*$/;
    @$paths         = grep { not /$qr_comment|$qr_empty/ } @$paths;
    
    ### $paths
    return $paths;
}; ## get_paths



## END MODULE
1;
#============================================================================#

=head1 NAME

Devel::Toolbox::Core::Config::Primary - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::Config::Primary version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::Config::Primary;

=head1 DESCRIPTION

=over

I<Anyone can tell the truth, 
but only very few of us can make epigrams.> 
-- W. Somerset Maugham

=back

=head1 METHODS 

=head2 new()

=head1 ACCSESSORS

Object-oriented accessor methods are provided for each parameter and result. 
They all do just what you'd expect. 

    $self               = $self->put_attr($string);
    $string             = $self->get_attr();

=head1 SEE ALSO

L<Some::Module|Some::Module>

=head1 INSTALLATION

This module is installed using L<Module::Build|Module::Build>. 

=head1 DIAGNOSTICS

=over

=item C<< some error message >>

Some explanation. 

=back

=head1 CONFIGURATION AND ENVIRONMENT

None. 

=head1 DEPENDENCIES

There are no non-core dependencies. 

=over

=item 

L<version|version> 0.99    E<nbsp>E<nbsp>E<nbsp>E<nbsp> 
# Perl extension for Version Objects

=back

This module should work with any version of perl 5.16.2 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any issues to: 
L<https://github.com/Xiong/devel-toolbox/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/Xiong/devel-toolbox>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

Xiong Changnian  C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 
Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut

__DATA__
# Location of the primary config path file, paths.* 
#   You may edit *here* and move that file. 
# This is not the place to list all the config files you have; 
#   ideally there is only one path *here*. 
# If multiple paths are given here, 
#   they will be searched until a 'paths' file is found.
#   So first in the list takes priority over any later.  
#
# paths.* may be any file accepted by Config::Any. 
# The 'paths' file contains paths to all config files; see which. 
# This information may be modified when this module is installed. 

/usr/share/devel-toolbox/core
/usr/local/share/devel-toolbox/core
/etc/devel-toolbox/core
/home/$user/.config/devel-toolbox/core
.config/devel-toolbox/core
file/dot-config-dt/core
file/test/orig/dot-config-dt/core
