package Devel::Toolbox::Core::Config;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib 'lib';
use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Config::Any;                # Load configs from any file format

# Exports
#~ use Sub::Exporter -setup => {   # Sophisticated custom exporter
#~     exports     => [ qw( declare ) ],
#~     groups      => { default => [ qw( declare ) ] },
#~ };

# Project modules
#~ use Devel::Toolbox;             # Simple custom project tool management
#~ use Devel::Toolbox::Core::Pool; # Global data pool IMPORTANT HERE!
use Devel::Toolbox::Core::Config::Master    # get master dirs  IMPORTANT HERE!
    'get_master_dirs';
use Devel::Toolbox::Core::Config::Cascade   # get config data  IMPORTANT HERE!
    get => { -as => 'get_cascaded' };
# Alternate uses
use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals
my $err     = Error::Base->new(
    -base   => '! DTC-Config:',
);
#~ our $U      = get_global_pool();            # common to all toolsets

## pseudo-globals
#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~     load_files();     # load all config files and merge contents into $U
#
#   $master_dirs is an aryref of dirs to search for master.* file
#   $config_dirs is contents of master.* file
#   $u is the parsed config to merge to $U
#   
#   ::Master::DATA      $master_dirs    contain master.* file
#   master.*            $config_dirs    contain config.* files
#   */config.* files    $u              contains config data
#   
sub load_files {
    my $master_dirs = {};           # search for master.* file
    my $config_dirs = {};           # search for config files
    my $u           = {};           # config data
    
    my $master_stems    = [qw( master foo )];   # master.yaml, master.ini,...
    my $config_stems    = [qw( config )];       # config.yaml, config.pl,...
    
    # Get primary config dir(s).
    $master_dirs        = get_master_dirs();
#~     ### Config - before interpolation
#~     ### $master_dirs
    _interpolate_placeholders(@$master_dirs);
    ### Config - after interpolation
    ### $master_dirs
    
    # Search for config files.
    $config_dirs        = get_cascaded({
        -dirs       => $master_dirs,    # filesystem dirs to search
        -stems      => $master_stems,   # filename stems to search
#~         -priority   => $literal,    # 'LEFT', 'RIGHT', 'STORE', 'RETAIN'
#~         -flip       => $bool,       # invert cross-join matrix
#~         -merge      => $bool,       # discard filename keys
#~         -stop       => $natural,    # stop after so many files
#~         -status     => $hashref,    # RETURNS status results
#~         -config     => $hashref,    # RETURNS configuration (merged)
    });
    
#~     ### Config - before interpolation
#~     ### $config_dirs
    _interpolate_placeholders( @{ $config_dirs->{'config_dirs'} } );
    ### Config - after interpolation
    ### $config_dirs
    
    # Now (attempt to) load all config files.
    my $config          = get_cascaded({
        -dirs       => $config_dirs,    # filesystem dirs to search
        -stems      => $config_stems,   # filename stems to search
#~         -priority   => $literal,    # 'LEFT', 'RIGHT', 'STORE', 'RETAIN'
#~         -flip       => $bool,       # invert cross-join matrix
#~         -merge      => $bool,       # discard filename keys
#~         -stop       => $natural,    # stop after so many files
#~         -status     => $hashref,    # RETURNS status results
        -config     => $u,          # RETURNS configuration (merged)
    });
    
    
    ### $u
}; ## load_files

#=========# EXTERNAL FUNCTION
#~     $username   = get_user();       # username of current script user
#
#   A variety of methods are used to try to get the username. First wins!
#   
sub get_user {
    my $user        = $ENV{LOGNAME} || $ENV{USER} || getlogin || getpwuid($<);
    
#~     # DEBUG ONLY BLOCK
#~     my $env_logname     = $ENV{LOGNAME}; 
#~     my $env_user        = $ENV{USER}; 
#~     my $getlogin        = getlogin; 
#~     my $getpwuid        = getpwuid($<);
#~     ### $env_logname
#~     ### $env_user
#~     ### $getlogin
#~     ### $getpwuid
    
    #### $user
    return $user;
}; ## get_user

#=========# INTERNAL FUNCTION
#~     _interpolate_placeholders();     # short
#
#   Acts directly on arguments so no need to assign. 
#   
sub _interpolate_placeholders {
    my $user    = get_user();
    @_          = map { s|/\$user/|/$user/|g; $_ } @_;  # This is not fancy. 

}; ## _interpolate_placeholders

#=========# EXTERNAL FUNCTION
#~     function();     # short
#
#   
#   
sub function {
    
    
    
}; ## function

    
    
    


## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Core::Config - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::Config version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::Config;

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





