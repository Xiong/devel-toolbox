package Devel::Toolbox::Set::New;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

# Core modules

# CPAN modules

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

# Pseudo-globals

## pseudo-globals
#----------------------------------------------------------------------------#

# This module exists mostly to provide the POD for the namespace. 
# In any case, everything inherits from it. 
# Might stick a few base methods in here. 

## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Set::New - Create a project, module, test, or toolset

=head1 VERSION

This document describes Devel::Toolbox::Set::New version v0.0.0

=head1 SYNOPSIS

    $ dt help new
    $ dt list new
    $ dt new My::Dist
    $ dt new module My::Module
    $ dt new test fubar
    $ dt new tool foo

=head1 DESCRIPTION

=head1 METHODS 

=head2 module()

    $self->module();
    $self->module( $template );

Create a new module from templates/Module.pm or from $template if given.

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

L<version|version> 0.99    
    E<nbsp>E<nbsp>E<nbsp>E<nbsp> # Perl extension for Version Objects

=back

This module should work with any version of perl 5.16.2 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any bugs or feature requests, or other issues through 
the web interface at
L<https://github.com/xiong/devel-toolbox/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/xiong/devel-toolbox>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

Xiong Changnian  C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut

