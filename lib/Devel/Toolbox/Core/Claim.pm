package Devel::Toolbox::Core::Claim;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib 'lib';
use File::Spec;                 # Portably perform operations on file names

# CPAN modules
use Error::Base;                # Simple structured errors with full backtrace
use Class::Inspector;           # Get info about a class and its structure
use Sub::Exporter -setup => {   # Sophisticated custom exporter
    exports     => [ qw( claim ) ],
    groups      => { default => [ qw( claim ) ] },
};

# Project module
use Devel::Toolbox;             # Simple custom project tool management
use Devel::Toolbox::Core::Pool; # Global data pool IMPORTANT HERE!

# Alternate uses
use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

# Pseudo-globals
my $err     = Error::Base->new(
    -base   => '! DTC-Claim:'
);

our $U      = get_global_pool();            # common to all toolsets

my $qr_errinc       = qr/locate.*?INC/;     # Can't locate Foo.pm in @INC...

## pseudo-globals
#----------------------------------------------------------------------------#

#=========# EXTERNAL FUNCTION
#~ claim '::Mytoolset';
#
#   This functions as a keyword or pseudo-pragma and does multiple things: 
#     * Expands a shortcut toolset (module) name; eg:
#       ::Mytoolset     => Devel::Toolbox::Set::Mytoolset
#     * require's the toolset
#     * exports all subroutines (tools) found in the toolset
#         into caller's namespace.
#   
#   The toolset name must be quoted. 
#   If you want the expansion then you must lead with '::' (aristdottle).
#   
sub claim {
    my $caller      = caller;
    say '[Claim] ', $caller, ' claiming [', @_, ']';                    #~#
    my $toolset     = shift;    # just what was given (in the request)
    my $perl_name   ;           # full Perlish module name
    my @path_parts  = (qw( Devel ::Toolbox ::Set ));    # search up from here
    my $base_name   = $caller;                          # export methods here
    my $eval_err    ;
    
    # Expand module name and load the toolset requested.
    unshift @path_parts, q{};       # try it naked, too
    while ( @path_parts ) {
        $perl_name      = join q{}, @path_parts, $toolset;
        ### $perl_name
        eval " require $perl_name ";    # must string eval!
        $eval_err       = $@;
        last if not $eval_err;
        ### $eval_err
        if ( not $eval_err =~ /$qr_errinc/ ){
            $err->crash([
                "$perl_name failed in require\n",
                $eval_err,
            ]);
        };
        pop @path_parts;            # perhaps a longer name was given
    };
    if ($eval_err) {                # no expansion successful
        ### $toolset
        eval " require $toolset ";  # try one last time, naked
        $eval_err       = $@;
    };
    if ($eval_err) {                # we tried everything
        ### $eval_err
        $err->crash("Can't require toolset $toolset");
    };
    
    # Import all methods (= tools in set).
    # Class::Inspector->methods() returns inherited methods, too. 
    # Is a class installed and/or loaded?
    # Class::Inspector->installed( $perl_name );
    # Class::Inspector->loaded( $perl_name );
    
    my @tools       = @{ Class::Inspector->functions( $perl_name ) };
    my $filter      = qr/get_global_pool|claim|declare|qv/;
    @tools          = grep { not /$filter/ } @tools;
#~ @tools = map { '&' . $_ } @tools;   #DEBUG
    ### @tools
    
#~ my @base_tools  ;
#~ @base_tools     = @{ Class::Inspector->functions( $base_name ) };
#~ ### @base_tools
    
    my $prepend     = lc $toolset;
    $prepend =~ s/:://g;
    
    _export_all ({
        -expkg      => $perl_name,
        -impkg      => $base_name,
        -symbols    => \@tools,
        -prepend    => $prepend,
    });
    
#~ @base_tools     = @{ Class::Inspector->functions( $base_name ) };
#~ ### @base_tools
    
}; ## claim

#=========# INTERNAL ROUTINE
#~     _export_all ({
#~         -expkg      => $exporting_package,   # 'Foo::Bar'
#~         -impkg      => $importing_package,   # 'Hoge::Piyo'
#~         -symbols    => \@symbol_list,        # [ sub, $scalar, %hash ]
#~         -prepend    => $string,              # 'foo_bar'
#~     });
#
#   This came from Exporter via Acme::Teddy. 
#   It exports, quite indiscriminately, everything in -symbols.
#   This version prepends a string to barewords; 
#    so Foo::quux() exports foo_quux() to Bar.
#   There is NO PREPENDING if a sigil is found; &quux exports quux(). 
#   A quietable warning is issued if a non-bareword is exported.
#   
sub _export_all {
    my $args        = shift;
    my $expkg       = $args->{-expkg};          # package to export from
    my $impkg       = $args->{-impkg};          # package to import into
    my @exsyms      = @{ $args->{-symbols} };   # aryref of strings
                                                #  include sigils $@%    
    my $prepend      = $args->{-prepend};       # prepended to exports
    ### $expkg
    ### $impkg
    ### @exsyms
    ### $prepend
    
    return if $expkg eq $impkg;                 # why bother?
    
    # Ripped from Exporter::Heavy::heavy_export()
    for my $exsym (@exsyms) {
        $exsym =~ s/^(\W)//;                    # strip off sigil and capture
        my $type = $1;
        ### $type
        if ( not $type ) {                      # the common case: 'quux'
            my $imsym   = join q{_}, $prepend, $exsym;      # e.g. set_tool()
#~             ### WHAT
#~             ### $expkg
#~             ### $exsym
#~             ### $impkg
#~             ### $imsym
            
            no strict 'refs';                   # For we doeth darke magiks.
            *{"${impkg}::$imsym"} = \&{"${expkg}::$exsym"};
#~             ### HERE 
        }
        else {
            my $imsym   = $exsym;                           # don't prepend
            warn "Exporting symbol: $type$exsym to $impkg"
                unless $U->{-core}{-flags}{-quiet};
            no strict 'refs';                   # For we doeth darke magiks.
            *{"${impkg}::$imsym"} =
                $type eq '&' ? \&{"${expkg}::$exsym"} :
                $type eq '$' ? \${"${expkg}::$exsym"} :
                $type eq '@' ? \@{"${expkg}::$exsym"} :
                $type eq '%' ? \%{"${expkg}::$exsym"} :
                $type eq '*' ?  *{"${expkg}::$exsym"} :
                $err->crash("Can't export symbol: $type$exsym");
#~             ### THERE
        };
    }; ## for exsym
}; ## _export_all

## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Core::Claim - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::Core::Claim version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Core::Claim;

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





