package Devel::Toolbox::Core::Config;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib qw| lib |;
use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Config::Any;                # Load configs from any file format

# Exports
use Sub::Exporter -setup => {   # Sophisticated custom exporter
    exports         => [qw| load_config_files |],
    groups  => { 
#       default     => [qw| load_config_files |],   # nah; explicitly import
    },
};

# Project modules
#~ use Devel::Toolbox;             # Simple custom project tool management
#~ use Devel::Toolbox::Core::Pool  # Global data pool IMPORTANT HERE!
#~     qw| :core |;
#~ 
use Devel::Toolbox              # Simple custom project tool management
    qw| :core |;

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals
my $err     = Error::Base->new(
    -base   => '! DTC-Config:',
);
our $U      = get_global_pool();            # common to all toolsets
my $hard_dirs   = [                         # yeh, hardcoded, sorry, TODO.
    '/home/$user/.config/devel-toolbox/configs',    # user      abs_dir
    '.config/devel-toolbox/configs',                # project   rel_dir
];
my $stem        = 'config';                 # config.yaml, config.ini

## pseudo-globals
#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~     load_config_files();     # load from disk and merge contents into $U
#
#   Takes no arguments, returns nothing.
#   
sub load_config_files {
    ### Config-lcf-begin
    ### $U
    
    my $u           = {};
    
    for my $dir (@$hard_dirs) {
        my $scout       = File::Spec->catfile( $dir, $stem );
        _interpolate_placeholders($scout);
#~         ### $scout
        
        # Launch this scout.
        my $rv          = Config::Any->load_stems({ 
            stems           => [$scout],    # aryref
            use_ext         => 1,           # format must match extension
            flatten_to_hash => 1,
        });
#~         ### $rv
        
        # Merge results with existing local pool.
        # $rv primary keys are fqfilenames; strip and merge.
        for my $pk ( keys $rv ) {
            %$u     = ( %$u, %{ $rv->{$pk} } );
        };
    }; ## for hard_dirs
    
    # Merge results with global pool.
    ### $u
    merge_global_pool($u);
    
    ### Config-lcf-end
    ### $U
    return 1;
}; ## load_config_files

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
    return 1;
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

Xiong Changnian C<< <xiong@cpan.org> >>

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





