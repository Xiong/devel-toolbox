package Devel::Toolbox::App::Core;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib 'lib';

# CPAN modules
use Exporter::Easy (        # Takes the drudgery out of Exporting symbols
    EXPORT      => [qw( using )],
);
use Scope::Guard;           # Lexically-scoped resource management

# Alternate uses
use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

# Pseudo-globals

## pseudo-globals
#----------------------------------------------------------------------------#

#~ say '[Core] callers:', caller[0], caller[1], '$';

sub new {
    my $class   = shift;
    my $self    = {};                           # always hashref
    bless ( $self => $class );
    $self->init(@_);                            # init remaining args
    return $self;
}; ## new

sub init {
    my $self        = shift;
    my $args        = shift or return $self;
    %{$self}        = ( %{$self}, %{$args} );   # merge
    return $self;
}; ## init

sub done_using {
    say '[Core] done_using [', @_, ']';
    
};

sub using {
    say '[Core] using [', @_, ']';
    
    # Do the nasty export
    my $expkg       = shift;
    $expkg          = 'Devel::Toolbox::Set' . $expkg;
    eval "require $expkg";
#~     my $impkg       = caller(1);
    my $impkg       = 'main';
    my $sym         = 'meow';
    say "[Core] Exporting $sym from $expkg to $impkg";
    {
        no strict 'refs';
        *{"${impkg}::$sym"} = \&{"${expkg}::$sym"};
    }
    
    # Create guard
    my $caller      = caller(0);
    my $guard_ref   = shift;
    say "[Core] Creating guard $guard_ref in $caller (using scope)";
    my $guard       = Scope::Guard->new(\&done_using);
    $guard_ref      = \$guard;
    
};

sub AUTOLOAD {
    our $AUTOLOAD;
    say "    Autoloading...$AUTOLOAD";
    say "    @_";
    ### @_
};

#~ sub DESTROY {
#~     say "[Core] Destroy @_";
#~ };

## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::App::Core - .................. 44 chars in PAUSE upload!

=head1 VERSION

This document describes Devel::Toolbox::App::Core version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::App::Core;

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





