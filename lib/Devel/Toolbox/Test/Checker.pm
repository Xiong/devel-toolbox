package Devel::Toolbox::Test::Checker;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules

# CPAN modules

# Project modules
use parent 'Devel::Toolbox::Core::Base';

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals

## pseudo-globals
#----------------------------------------------------------------------------#
# $_[0]: Checker class, usually 'main' (caller).
#                         $_[1]                        $_[2]  $_[3]
#   {check()}             $trap (have)                 {want} {diag}

sub return_is           { $_[1]->return_is        ( 0, $_[2], $_[3]) };
sub stdout_is           { $_[1]->stdout_is        (    $_[2], $_[3]) };
sub stderr_is           { $_[1]->stderr_is        (    $_[2], $_[3]) };

sub die_like            { $_[1]->die_like         (    $_[2], $_[3]) };

# Note that the is_deeply test does not accept an index. 
# Even for array accessors, it operates on the entire array.
sub return_is_deeply    { $_[1]->return_is_deeply (    $_[2], $_[3]) };

sub quiet               { $_[1]->quiet            (           $_[3]) };
sub died                { $_[1]->did_die          (           $_[3]) };


## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Test::Checker - Standard checkers for Test::Valet cases

=head1 VERSION

This document describes Devel::Toolbox::Test::Checker version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Test::Checker;

=head1 DESCRIPTION

=over

I<Anyone can tell the truth, > 
I<but only very few of us can make epigrams.> 
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





