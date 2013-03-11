package Devel::Toolbox::Core::Config::Cascade;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
#~ use lib 'lib';
use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Config::Any;                # Load configs from any file format
use Hash::Merge();              # Merge deep hashes into a single hash

#~ use Sub::Exporter -setup => {   # Sophisticated custom exporter
#~     exports     => [ qw( declare ) ],
#~     groups      => { default => [ qw( declare ) ] },
#~ };

# Project modules
#~ use Devel::Toolbox;             # Simple custom project tool management
#~ use Devel::Toolbox::Core::Pool; # Global data pool IMPORTANT HERE!

# Alternate uses
use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals
my $err     = Error::Base->new(
    -base   => '! DTC-Config-Cascade:',
);
#~ our $U      = get_global_pool();            # common to all toolsets

## pseudo-globals
#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~ my $config  = Devel::Toolbox::Core::Config::Cascade->get({
#~     -paths      => \@paths,     # filesystem paths to search
#~     -stems      => \@strings,   # filename stems to search
#~     -priority   => $literal,    # 'LEFT', 'RIGHT', 'STORE', 'RETAIN'
#~     -flip       => $bool,       # invert cross-join matrix
#~     -merge      => $bool,       # discard filename keys
#~     -stop       => $natural,    # stop after so many files
#~     -status     => $hashref,    # RETURNS status results
#~     -config     => $hashref,    # RETURNS configuration (merged)
#~ });
#
#   
#   
sub get {
    my $args        = shift;
       $args        = shift
        if not ref $args;       # discard class if called as class method
    ### $args
    
    # Arguments... 
    #  var                       -key          default
    my @paths       = @{ $args->{-paths}    // [ q{.} ]         };
    my @stems       = @{ $args->{-stems}    // [ q{config} ]    };
    my $priority    =    $args->{-priority} // 'RIGHT'          ;
    my $flip        =    $args->{-flip}     // 0                ;
    my $merge       =    $args->{-merge}    // 1                ;
    my $stop        =    $args->{-stop}     // undef            ;
    my $status      = ${ $args->{-status}   // \{}              };
    my $config      = ${ $args->{-config}   // \{}              };
#~ say 'cascade-before: ', $config;                            # DEBUG ONLY ~#
    
    # Fixup; see Hash::Merge 'BUILT-IN BEHAVIORS'.
    # Don't validate (in case H::M is extended) but be more tolerant
    $priority       = uc $priority;             # forgive lowercase
    $priority =~ s/^\W//;                       # forgive a leading symbol
    $priority =~ s/$|_PRECEDENT$/_PRECEDENT/;   # append if forgotten
    $priority =~ s/STORE_/STORAGE_/;            # allow some abbreviation
    $priority =~ s/RETAIN_/RETAINMENT_/;        # allow some abbreviation
    Hash::Merge::set_behavior( $priority );     # global?
        
    # Internal use...
    my $eval_err    ;           # don't let $@ get stale
    my @good_files  ;           # files found to contain config data
    my $raw         = {};       # data as it comes from Config::Any
    
    # Cross-join; try every stem with every path.
    my @searches    ;
    if ( not $flip ) {          # i, j
        for my $path (@paths) {
            for my $stem (@stems) {
                push @searches, File::Spec->catfile( $path, $stem );
            };
        };
    }
    else {                      # j, i
        for my $stem (@stems) {
            for my $path (@paths) {
                push @searches, File::Spec->catfile( $path, $stem );
            };
        };
    }; ## if not flip else flip
    
#~     ### @paths
#~     ### @stems
#~     ### @searches
    
    # Search all files and load.
    for my $search (@searches) {
#~         ### $search
        # Try to load this search.
        my $rv          ;
        eval { 
            # Read and load the file(s) (with any extension), if possible.
            $rv             = Config::Any->load_stems({ 
                stems           => [$search],   # aryref
                use_ext         => 1,           # format must match extension
                flatten_to_hash => 1,
            });
            # Returns AoH keyed on actual filename.
        };
        $eval_err   = $@;
#~         ### $eval_err
        next if $eval_err;                  # keep trying
#~         ### $rv
        next if not $rv;                    # didn't even return a hashref
        
        # Save successful searches.
#~         ### PUSH
        push @good_files, keys $rv;
        
        # "Merge" without possibility of key collision...
        # ... since primary keys are fqfilenames.
        %$raw    = ( %$raw, %$rv );
        
        # Is that enough files?
        if ( defined $stop ) {
            last if scalar @good_files >= $stop;
        };
        
    }; ## for searches
    $status->{-good_files}  = \@good_files;
    
    ### @good_files
    ### $raw
    
    # Merge out filename keys if requested.
    # Operate on the underlying hash, not on the reference. 
    if ($merge) {
        for my $file (@good_files) {
            %$config     = %{ Hash::Merge::merge( $config, $raw->{$file} ) };
        };
    }
    else {
        %$config     = %$raw;
    }; ## if merge
    
    
#~ say 'cascade-after: ', $config;                             # DEBUG ONLY ~#
#~     $args->{-status}    = \$status;
#~     $args->{-config}    = \$config;
    return $config;
}; ## get



## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Core::Config::Cascade - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::Config::Cascade version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::Config::Cascade;

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

