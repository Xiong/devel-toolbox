package {{$module_name}};
# Choose minimum perl interpreter version; delete the rest.
# Do you want to enforce the bugfix level?
#~ use 5.008008;   # 5.8.8     # 2006  # oldest sane version
#~ use 5.008009;   # 5.8.9     # 2008  # latest 5.8
#~ use 5.010001;   # 5.10.1    # 2009  # say, state, switch
#~ use 5.012003;   # 5.12.5    # 2011  # yada
#~ use 5.014002;   # 5.14.3    # 2012  # pop $arrayref, copy s///r
#~ use 5.016002;   # 5.16.2    # 2012  # 
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



## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Error::Base - Simple structured errors with full backtrace

=head1 VERSION

This document describes Error::Base version v1.0.2

=head1 SYNOPSIS

    use Error::Base;

=head1 DESCRIPTION

=over

I<J'avais cru plus difficile de mourir.> 
-- Louis XIV

=back

=head1 METHODS 

=head2 new()

=head1 ACCSESSORS

Object-oriented accessor methods are provided for each parameter and result. 
They all do just what you'd expect. 

    $self               = $self->put_base($string);
    $self               = $self->put_type($string);
    $self               = $self->put_mesg($string);
    $self               = $self->put_quiet($string_or_aryref);
    $self               = $self->put_nest($signed_int);
    $self               = $self->put_prepend($string);
    $self               = $self->put_indent($string);
    $string             = $self->get_base();
    $string             = $self->get_type();

=head1 SEE ALSO

L<Error::Base::Cookbook|Error::Base::Cookbook>

=head1 INSTALLATION

This module is installed using L<Module::Build|Module::Build>. 

=head1 DIAGNOSTICS

=over

=item C<< excessive backtrace >>

Attempted to capture too many frames of backtrace. 
You probably mis-set C<< -nest >>, reasonable values of which are perhaps 
C<-2..3>.

=item C<< unpaired args: >>

You do I<not> have to pass paired arguments to most public methods. 
Perhaps you passed an odd number of args to a private method. 

=item C<< bad reftype in _late >>

Perhaps you attempted to late-interpolate a reference other than to 
a scalar, array, or hash. 
Don't pass such references as values to any key with the wrong sigil. 

=item C<< bad reftype in _expand_ref >>

You passed a hashref or coderef to C<-mesg>. Pass a simple string or arrayref. 

=item C<< no $self >>

Called a method without class or object. Did you call as function?

=item C<< stringifying unthrown object >>

An object of this class will stringify to its printable error message 
(including backtrace if any) when thrown. There is nothing to see (yet) if 
you try to print an object that has been constructed but not (yet) thrown. 
This error is not fatal; it is returned as the stringification. 

=item C<< in _late eval: >>

Attempted to late-interpolate badly. Check your code. The interpolation 
failed so you cannot expect to see the correct error message text. 
On the offchance that you would like to see the stack backtrace anyway, 
this error is not fatal. 

=back

=head1 CONFIGURATION AND ENVIRONMENT

Error::Base requires no configuration files or environment variables.

=head1 DEPENDENCIES

There are no non-core dependencies. 

=over

=item 

L<version|version> 0.99    E<nbsp>E<nbsp>E<nbsp>E<nbsp> # Perl extension for Version Objects

=item 

L<overload|overload>    E<nbsp>E<nbsp>E<nbsp>E<nbsp> # Overload Perl operations

=item 

L<Scalar::Util|Scalar::Util>    E<nbsp>E<nbsp>E<nbsp>E<nbsp> # General-utility scalar subroutines

=back

This module should work with any version of perl 5.8.8 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any bugs or feature requests to
C<bug-error-base@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: L<https://github.com/Xiong/error-base>. 

=head1 THANKS

Grateful acknowledgement deserved by AMBRUS for coherent API suggestions. 
Any failure to grasp them is mine. 

=head1 AUTHOR

Xiong Changnian  C<< <xiong@cpan.org> >>

=head1 LICENCE

Copyright (C) 2011, 2013 Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_base

=head2 put_type

=head2 put_mesg

=head2 put_quiet

=head2 put_nest

=head2 put_prepend

=head2 put_indent

=head2 get_base

=head2 get_type

=head2 get_mesg

=head2 get_quiet

=head2 get_nest;

=head2 get_prepend

=head2 get_indent

=head2 get_all

=head2 get_lines

=head2 get_frames

=end   fool_pod_coverage

=cut





