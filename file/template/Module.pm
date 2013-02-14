package {{$module_name}};
# Choose minimum perl interpreter version; delete the rest.
# Do you want to enforce the bugfix level?
#~ use 5.008008;   # 5.8.8     # 2006  # oldest sane version
#~ use 5.008009;   # 5.8.9     # 2008  # latest 5.8
#~ use 5.010001;   # 5.10.1    # 2009  # say, state, switch
#~ use 5.012003;   # 5.12.5    # 2011  # yada
#~ use 5.014002;   # 5.14.3    # 2012  # pop $arrayref, copy s///r
#~ use 5.016002;   # 5.16.2    # 2012  # __SUB__
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

{{$module_name}} - {{$module_abstract}}

=head1 VERSION

This document describes {{$module_name}} version {{$version}}

=head1 SYNOPSIS

    use {{$module_name}};

=head1 DESCRIPTION

=over

I<{{$tagquote}}> 
-- {{$tagquote_credit}}

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

{{$module_name}} requires no configuration files or environment variables.

=head1 DEPENDENCIES

There are no non-core dependencies. 

=over

=item 

L<version|version> 0.99    E<nbsp>E<nbsp>E<nbsp>E<nbsp> # Perl extension for Version Objects

=back

This module should work with any version of perl 5.16.2 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any bugs or feature requests, or other issues through 
the web interface at
L<https://github.com/{{$author_github}}/{{$dist_name}}/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/{{$author_github}}/{{$dist_name}}>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

{{$author_name}}  C<< <{{$author_email}}> >>

=head1 LICENSE

Copyright (C) {{$copyright_years}} {{$author_name}} C<< <{{$author_email}}> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut





