package Devel::Toolbox;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use version; our $VERSION = qv('v0.0.0');

# Exporter first.
BEGIN {
    require Exporter;               # Must use the old fellow here
    our @ISA    = 'Exporter';
    our @EXPORT = 'using';          # That's right.
}

# Core modules

# CPAN modules

# Project modules
use Devel::Toolbox::Core::Using;    # Guts of 'using' function

# Alternate uses
#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

# Clean after all use
## use
#============================================================================#

# Pseudo-globals

## pseudo-globals
#----------------------------------------------------------------------------#

sub import {
    my $caller      = caller;
    ### $caller
    
    our @EXPORT     ;
    ### @EXPORT
    
    Devel::Toolbox->export_to_level( 1, @EXPORT );
};



## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox - Simple custom project tool management

=head1 VERSION

This document describes Devel::Toolbox version v0.0.0

*** NONFUNCTIONAL ***

=head1 SYNOPSIS

    $ dt setup
    $ dt help
    $ dt list sets
    $ dt list tools
    $ dt list sometool
    $ dt new My::Dist
    $ dt new test fubar
    $ dt build
    $ dt release

=head1 DESCRIPTION

=over

I<The computer should be doing the hard work. 
That's what it's paid to do, after all.> 
-- Larry Wall

=back

Perl developers are offered a range of machinery with which to carry out 
various tasks not strictly part of writing production code: starting a new 
project, starting new modules, testing (testing testing), building a CPAN 
distribution, uploading, and so forth. These machines range from simple 
and quaint to modern and enormous. 

Devel::Toolbox steers a middle course; it attempts to offer more utility 
for less investment. We assume that you would rather make your project 
work than learn how your toolbox works; and you may not need great power 
to do that. 

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

