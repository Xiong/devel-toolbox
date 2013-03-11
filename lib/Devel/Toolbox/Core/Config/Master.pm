package Devel::Toolbox::Core::Config::Master;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
#~ use lib 'lib';
#~ use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Sub::Exporter -setup => {   # Sophisticated custom exporter
    exports     => [ qw( get_master_dirs ) ],
    groups      => { default => [ qw( get_master_dirs ) ] },
};

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
    -base   => '! DTC-Config-Master:',
    _close  => 'Failed to close DATA after reading.',
);
#~ our $U      = get_global_pool();            # common to all toolsets

## pseudo-globals
#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~     $dirs  = get_master_dirs();     # get dirs to master.* file
#
#   
#   
sub get_master_dirs {
    my $dirs       ;
    @$dirs         = <DATA>;
    close DATA 
        or $err->crash ( $err->{ _close } );
    
    # Filter out comments and similar rubbish.
    chomp @$dirs;
    my $qr_comment  = qr/^\s*#/;
    my $qr_empty    = qr/^\s*$/;
    @$dirs         = grep { not /$qr_comment|$qr_empty/ } @$dirs;
    
    ### $dirs
    return $dirs;
}; ## get_master_dirs



## END MODULE
1;
#============================================================================#

=head1 NAME

Devel::Toolbox::Core::Config::Master - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::Config::Master version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::Config::Master;

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
# Location(s) of the master config directory file, master.* 
#   You may edit *here* and move that file. 
# *This* is not the place to list all the config files you have; 
#   ideally there is only one directory *here*. 
# If multiple dirs are given *here*, 
#   they will be searched until a master file is found.
#   Search will halt after the first master file is found.  
#
# master.* may be any file accepted by Config::Any, with correct extension. 
# The master.* file contains dirs to all config files; see which. 
# *This* information may be modified when this module is installed. 

/usr/share/devel-toolbox/core
/usr/local/share/devel-toolbox/core
/etc/devel-toolbox/core
/home/$user/.config/devel-toolbox/core
.config/devel-toolbox/core
file/dot-config-dt/core
file/test/orig/dot-config-dt/core
