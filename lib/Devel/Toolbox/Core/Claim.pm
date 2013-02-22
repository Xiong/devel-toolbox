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
use Exporter::Easy (            # Takes the drudgery out of Exporting symbols
    EXPORT      => [qw( claim )],
);
use Class::Inspector;           # Get info about a class and its structure

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

# Pseudo-globals

my $err             = Error::Base->new(
                        -base   => '! DT-Claim:'
);

## pseudo-globals
#----------------------------------------------------------------------------#

sub claim {
    my $caller      = caller;
#~     ### $caller

#~     say '[Claim] ', $caller, ' claiming [', @_, ']';                    #~#
    
    # Load the toolset requested.
    my $toolset     = shift;    # just what was given (in the request)
    $toolset =~ s/^:://;        # since we suggest a leading double-colon
    my $full_name   ;           # full path to module name
    my $perl_name   ;           # Perlish module name
    my @path_parts  = (qw( Devel Toolbox Set ));
    while ( @path_parts ) {
        $full_name      = File::Spec->catfile( @path_parts, $toolset );
        $full_name      .= q{.pm};
        my $caller = caller;
#~  say q*DEBUG: $full_name: '*, $full_name, q*'*;                         #~#
        eval { require $full_name };
        last if not $@;
        pop @path_parts;        # perhaps a longer name was given
    };
    if ($@) {                   # we tried everything
        $err->crash("Can't find toolset $toolset");
    };
    $perl_name      = join '::', @path_parts, $toolset;
    
    # Import all methods (= tools in set). 
#~     ### $full_name
    ### $perl_name
#~ # Is a class installed and/or loaded
#~ Class::Inspector->installed( 'Foo::Class' );
#~ Class::Inspector->loaded( 'Foo::Class' );

#~     my @tools       = Class::Inspector->methods( 
#~                         $perl_name, 'full', 'public' 
#~                     );
    
    my @tools       = @{ Class::Inspector->functions( $perl_name ) };

#~     ### @tools
    my $filter      = qr/claim|qv/;
    @tools          = grep { not /$filter/ } @tools; 
    ### @tools
    
    my $base_name   = 'Devel::Toolbox::Core::Base';
    my @base_tools  ;
    @base_tools     = @{ Class::Inspector->functions( $base_name ) };
    ### @base_tools
    
    export_all ({
        -expkg      => $perl_name,
        -impkg      => $base_name,
        -symbols    => \@tools,
    });
    
    @base_tools     = @{ Class::Inspector->functions( $base_name ) };
    ### @base_tools
    
}; ## claim

sub export_all {
    my $args        = shift;
    my $expkg       = $args->{-expkg};          # package to export from
    my $impkg       = $args->{-impkg};          # package to import into
    my @symbols     = @{ $args->{-symbols} };   # aryref of strings
                                                #  include sigils $@%
    my $type        ;
    
    ### $impkg
    ### $expkg
    ### @symbols
    
    # Ripped from Exporter::Heavy::heavy_export()
    foreach my $sym (@symbols) {
        # For we doeth darke magiks.
        no strict 'refs';
        # shortcut for the common case of no type character
        (*{"${impkg}::$sym"} = \&{"${expkg}::$sym"}, next)
            unless $sym =~ s/^(\W)//;
        $type = $1;
        *{"${impkg}::$sym"} =
            $type eq '&' ? \&{"${expkg}::$sym"} :
            $type eq '$' ? \${"${expkg}::$sym"} :
            $type eq '@' ? \@{"${expkg}::$sym"} :
            $type eq '%' ? \%{"${expkg}::$sym"} :
            $type eq '*' ?  *{"${expkg}::$sym"} :
            die "Can't export symbol: $type$sym\n", $!;
    }
}; ## export_all



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





