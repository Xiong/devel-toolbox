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
#~ use Sub::Exporter -setup => {   # Sophisticated custom exporter
#~     exports     => [ qw( declare ) ],
#~     groups      => { default => [ qw( declare ) ] },
#~ };

# Project modules
#~ use Devel::Toolbox;             # Simple custom project tool management
#~ use Devel::Toolbox::Core::Pool; # Global data pool IMPORTANT HERE!
use Devel::Toolbox::Core::Config::Primary;  # get config paths IMPORTANT HERE!

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
#   $paths is an aryref of paths to search for paths.* file
#   $configs is contents of paths.* file
#   $u is the parsed config to merge to $U
#   
sub load_files {
    my $u           ;           # hashref: config data
    my $configs     ;           # aryref:  search for config files
    my $paths       ;           # aryref:  search for paths.* file
    
    # Get primary config path(s).
    $paths      = Devel::Toolbox::Core::Config::Primary::get_paths();
#~     ### Config - before interpolation
#~     ### $paths
    _interpolate_placeholders(@$paths);
    ### Config - after interpolation
    ### $paths
    
    $configs    = _do_config_any({
        -paths      => $paths,          # searching for paths.* file
        -stems      => ['paths', 'foo'],       # stem of paths.* file
    });
    
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#    # FLATTEN-OUT LOGIC -- TODO
    
#    #~             ### $rv;
#    #~             say 'KEYS: ';
#    #~             say for keys %$rv;
#                my ($key)   = keys %$rv;        # force list context
#    #~             ### $key;
#                die 'NO KEY' if not $key;       # get out now; avoid warning
#                $configs    = $rv->{$key};      # get the aryref
    
#            next if not $configs;               # found only a bad file
            
#            # Store the location of the good file.
#            $u->{-core}{-path}{-paths_file}     = $try;
    
#        # Crash on failure.
#        if ( not $configs ) {
#            @$paths     = map { qq{\n} . $_ } @$paths;
#            $err->crash([ 
#                "Can't find any primary config path file, 'paths.*'" , qq{\n},
#                " Searched:", @$paths,
#            ])
#        };

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


    ### Config - before interpolation
    ### $configs
#~     _interpolate_placeholders(@$configs);
#~     ### Config - after interpolation
#~     ### $configs
    
    # Now (attempt to) load all config files.
    
    
    
    
    
    
    
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

#=========# INTERNAL FUNCTION
#~     $hashref    = _do_config_any({
#~         -paths      => \@paths,         # paths only
#~         -stems      => \@stems,         # filename stems; C::A will search
#~     });
#
#   
#   
sub _do_config_any {
    my $args        = shift;
    my @paths       = @{ $args->{-paths} };
    my @stems       = @{ $args->{-stems} };
    
    my $found       = [];       # returns an aryref
    
    my $eval_err    ;           # don't let $@ get stale
    
    # Cross-join; try every stem with every path. Returns AoA.
    my @searches    ;
    for my $path (@paths) {
        for my $stem (@stems) {
            push @searches, File::Spec->catfile( $path, $stem );
        };
    };
    ### @paths
    ### @stems
    ### @searches
    
    # Search all files and load.
    my $rv          ;
    eval { 
        # Read and load the file(s) (with any extension), if possible.
        $rv             = Config::Any->load_stems({ 
            stems           => \@searches,  # aryref
            use_ext         => 1,           # format must match extension
                flatten_to_hash => 1,
        });
        # Returns AoH keyed on actual filename.
    };
    $eval_err   = $@;
    ### $eval_err
    next if $eval_err;                  # not a good stem; keep trying
    ### $rv
    push @$found, $rv;  # good; store results
    
    ### $found
    return $found;
}; ## _do_config_any

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





