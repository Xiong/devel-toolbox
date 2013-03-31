package Devel::Toolbox::Core::Pool;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib qw| lib |;
use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
#~ use Class::Inspector;           # Get info about a class and its structure
use Hash::Merge();              # Merge deep hashes into a single hash
use Hash::Flatten;              # Flatten/unflatten complex data hashes
use List::MoreUtils             # The stuff missing in List::Util
    qw| any |;
use Sub::Exporter -setup => {   # Sophisticated custom exporter
    exports         => [qw| 
                                get_global_pool
                                 flat_from_pool
                              merge_global_pool
                               init_global_pool
        |],
    groups  => { 
        default     => [qw| 
                                get_global_pool 
                                 flat_from_pool
        |],
        core        => [qw|
                                       :default
                              merge_global_pool
        |],
        main        => [qw|
                                         :core
                               init_global_pool
        |],
    },
};  ## use sub exporter

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals
my $err     = Error::Base->new(
    -base   => '! DTC-Pool:'
);

my $do_hash_merge   = Hash::Merge->new( 'RIGHT_PRECEDENT' );
my $do_hash_flat    = Hash::Flatten->new({
    HashDelimiter       => ' _', 
    ArrayDelimiter      => '__',
    EscapeSequence      => 'xxx',
    escapesequence      => 'xxx',
#~     DisableEscapes      => 1,
});
#~ my $hash_flat_opts  = {
#~     HashDelimiter       => '_', 
#~     ArrayDelimiter      => '*',
#~     EscapeSequence      => '#',
#~     DisableEscapes      => 1,
#~ };

# $U is a hashref, the big global pool per each script invocation of D::T. 
# The pool contains stuff common to all D::T modules. Look here first.
# $U is an implicit argument to all tools.
#   Next line is for toolset modules: 
#~ our $U      = get_global_pool();            # common to all toolsets

# Since this module defines that function, get_global_pool();
#  $U is instead set directly during init_global_pool().
our $U      ;                               # common to all toolsets

#   Only calling *scripts* should incorporate this block.
#   Callers other than 'main' will fatal! 
#~ # Define pool first! 
#~ BEGIN {                         #    $::U or $main::U
#~     $::U      = {}; 
#~     say 'dt-BEGIN: ', $::U;
#~     # Make get_global_pool work now.
#~     use Devel::Toolbox::Core::Pool qw| :main |;
#~     init_global_pool($::U);
#~ }
#~ use Devel::Toolbox;             # Simple custom project tool management

## pseudo-globals
#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~ our $U      = get_global_pool();            # common to all toolsets
#
#   Get an alias to the global pool. You should do this in your toolset FIRST.  
#   If you accept the default import when use'ing Devel::Comments,
#    then $Your::Toolset::U will already be defined. 
#   
sub get_global_pool {
    my $caller = caller;
    ### Pool-ggp
    ### $caller
    ### $main::U
    return $U;
}; ## get_global_pool

#=========# EXTERNAL FUNCTION
#~ Devel::Toolbox::Core::Pool::init_global_pool($U);  # minimum initialization
#
#   init($U) sets some minimal keys; this should be done only once. 
#   As a safeguard, this fatals if called from any other than package main. 
#   
sub init_global_pool {
    my $mainU   = shift;
    scalar caller eq 'main'
        or $err->crash( 'Attempt to re-initialize $U in package ', caller );
    our $U      = $mainU;
    
    # Initial values.                                   TODO
#~     $U->{somekey}      = 42;
    
    return $mainU;
}; ## init_global_pool

#=========# EXTERNAL FUNCTION
#~ merge_global_pool($u);
#~ merge_global_pool( $u, $caller );
#
#   Merge local pool into global pool. 
#   New values overwrite old values without touching other keys.
#   Defaults to namespacing under a compact'ed form of caller;
#       this can be overridden with another caller.
#       You probably don't want to do this outside of ::Core.
#   
sub merge_global_pool {
    my $arg         = shift or return $U;
    my $caller      = shift // caller;      # allow fake caller
    ### Pool-mgp
    ### $caller
    ### $U
    
    # Primary key is compacted caller; 
    #   this means each caller has its own namespace.
    my $pk          = $caller =~ s/^Devel::Toolbox::(\w)(?:[^:]*::)/DT$1-/r;
    my $keyed       = { $pk => $arg };
#~     %{$U}           = ( %{$U}, %{$keyed} );   # merge
    %$U = %{ $do_hash_merge->merge( $U, $keyed ) };
    ### after merge
    ### $U
    return $U;
}; ## merge_global_pool

#=========# EXTERNAL FUNCTION
#~ my $flat_hash   = flat_from_pool({ 
#~     want_keys       => $aryref,
#~     strip_level     => $natural,
#~ });
#
#   want_keys   : aryref of strings         optional
#                   list of keys to return flattened
#                   default is all keys
#   
#   strip_level : natural number            optional
#                   strip these many levels of keys before flattening
#                   default is 0
#   
#   Specified keys are extracted from pool
#     and flattened into a single-level hashref.
#   
sub flat_from_pool {
    my $args            = shift;
#~     ### $args
    my @want_keys       = @{ $args->{want_keys}         // []       };
    my $strip_level     =    $args->{strip_level}       // 0        ;
    
    my $want_all_keys   = @want_keys ? 0 : 1;
    
    my $flat            = {};       # return value
    my $acc             = {};       # accumulator
    my $u               ;
    %$u                 = %$U;      # local copy this sub only
    
    while ($strip_level) {
        # Strip one level's worth of keys and merge results.
        $acc    = {};               # start clean
        for my $pk ( keys $u ) {
            if (
                   ( $want_all_keys )
                or ( any { /^$pk$/ } @want_keys )           # key is wanted
            ) 
            {
                %$acc   = %{ $do_hash_merge->merge( $acc, $u->{$pk} ) };
            };
        };
        $strip_level--;
        %$u     = %$acc;   # recycle for next pass through while loop
    };
    
    $flat       = $do_hash_flat->flatten( $u );
    
    # Since the Hash::Flatten::flatten routine does a terrible job with 
    #   any combination of options; fix the result by deleting illegal spaces.
    $flat          = _fix_flat($flat);
#~     ### $flat
    
    return $flat;
}; ## flat_from_pool

#=========# INTERNAL ROUTINE
#~ my $hashref     = _fix_flat($hashref_corrupted);
#
#   Deletes Hash::Flatten junk from a single-level hashref.
#   
sub _fix_flat {
    my $in      = shift;
    my $ok      ;
#~     ### $in
    
    if ( ref $in ne 'HASH' ) { return $in };    # not a hashref; crash? TODO
    
    %$ok     = map {                        # return a key/value list
        my $key     = $_;                   # preserve original key
        $key =~ s/\s_/_/g;
        ( $key, $in->{$_} )                 # return value of original key
    } keys %$in;
    
    return $ok;
}; ## _fix_flat




## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Core::Pool - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::Pool version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::Pool;

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





