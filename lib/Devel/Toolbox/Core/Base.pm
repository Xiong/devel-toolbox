package Devel::Toolbox::Core::Base;
#~ package Class::Base::Tiny;
use 5.008008;   # 5.8.8     # 2006  # oldest sane version
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

#============================================================================#

#=========# CLASS METHOD
#~ my $self    = My::Class->new({
#~                 key         => 'value',
#~               });
#
#   Classic hashref-based-object constructor.
#   
sub new {
    my $class   = shift;
    my $self    = {};
    bless ( $self => $class );
    $self->init(@_);
    return $self;
}; ## new

#=========# OBJECT METHOD
#~ $self->init({
#~     key         => 'value',
#~ });
#
#   Standard hashref-merge initializer. 
#   New values overwrite old values without touching other keys.
#   
sub init {
    my $self        = shift;
    my $args        = shift or return $self;
    %{$self}        = ( %{$self}, %{$args} );   # merge
    return $self;
}; ## init

## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Core::Base - Simple, no-frills hashref-object base class

=head1 VERSION

This document describes Devel::Toolbox::Core::Base version v0.0.0

=head1 SYNOPSIS
    
    package My::Class;
    use parent 'Devel::Toolbox::Core::Base';
    my $self    = My::Class->new({
                    key         => 'value',
                  });

=head1 DESCRIPTION

=over

I<< His refuge will be the impregnable rock... >> 
-- Isaiah 33:16

=back

Does very little; so unlikely to fail you in any way. 

=head1 METHODS 

=head2 new()

    $blessed_hashref    = Class->new(@args);
    $blessed_hashref    = Class->new(\%attrs);

Blesses a reference to a new, anonymous hash into C<< Class >>. 
Remaining C<< @args >> are passed to C<< init() >>.

If you call C<< new() >> without overriding C<< init() >>, 
then you should just pass a single hashref. 

=head2 init()

    $object->init(\%attrs);

Merges C<< %attrs >> into C<< %$object >>, with C<< %attrs >> taking precedence. 

You might override C<< init() >> to do something else. You might also: 
    
    package My::Class;
    sub init {
        my @args    = @_;
        {...}       # some domain-specific initialization
        SUPER::init(\%attrs);
    };

If so, you pick out from C<< @args >> an C<< \%attrs >> hashref. 
If you pass a list, the first element will be shifted off and dereferenced; 
remaining elements will be discarded. 

=head1 SEE ALSO

=begin html

<!--

=end html

There are at least five thousand base classes on CPAN; 
I lack the time to say what they all do. 

L<< Badger::Base|Badger::Base >> E<10> E<8> E<9>
Contains a lot of error-handling stuff, with status package variables. 

L<< Class::Base|Class::Base >> E<10> E<8> E<9>
Self-deprecated in favor of Badger::Base.

L<< Object::Tiny|Object::Tiny >> E<10> E<8> E<9>
Creates accessors for all attributes declared on the use-line. 

L<< Class::Accessor|Class::Accessor >> E<10> E<8> E<9>
Creates accessors/mutators and supports L<< Moose|Moose >> roles. 

L<< Package::Base|Package::Base >> E<10> E<8> E<9>
Abstract base class implements, as no-op, all possible methods. Plus stuff.

L<< Class::Ref|Class::Ref >> E<10> E<8> E<9>
"Automatic OO wrapping of container references", 
"...  no blessing of any of the data wrapped..."

L<< Class::Std|Class::Std >> E<10> E<8> E<9>
The canonical inside-out (flyweight object) base class. Unmaintained.

L<< Class::InsideOut|Class::InsideOut >> E<10> E<8> E<9>
Robust but minimal inside-out objects. Generates accessors and DESTROY method.

L<< UNIVERSAL|UNIVERSAL >> E<10> E<8> E<9>
Don't forget that all classes always inherit from UNIVERSAL, 
which provides C<< isa() >>, C<< can() >>, C<< DOES() >>, and C<< VERSION() >>.

=begin html

-->

<P>
There are at least five thousand base classes on CPAN; 
I lack the time to say what they all do. 
</P>
<DL>

<DT>    <a href="http://search.cpan.org/perldoc?Badger%3A%3ABase" 
            class="podlinkpod">Badger::Base</a> 
<DD>    Contains a lot of error-handling stuff, with status package variables. 

<DT>    <a href="http://search.cpan.org/perldoc?Class%3A%3ABase"
            class="podlinkpod"">Class::Base</a> 
<DD>    Self-deprecated in favor of Badger::Base.

<DT>    <a href="http://search.cpan.org/perldoc?Object%3A%3ATiny"
            class="podlinkpod"">Object::Tiny</a> 
<DD>    Creates accessors for all attributes declared on the use-line. 

<DT>    <a href="http://search.cpan.org/perldoc?Class%3A%3AAccessor"
            class="podlinkpod"">Class::Accessor</a> 
<DD>    Creates accessors/mutators and supports 
        <a href="http://search.cpan.org/perldoc?Moose"
            class="podlinkpod"">Moose</a> roles. 

<DT>    <a href="http://search.cpan.org/perldoc?Package%3A%3ABase"
            class="podlinkpod"">Package::Base</a> 
<DD>    Abstract base class implements, as no-op, all possible methods. 
        Plus stuff.

<DT>    <a href="http://search.cpan.org/perldoc?Class%3A%3ARef"
            class="podlinkpod"">Class::Ref</a> 
<DD>    "Automatic OO wrapping of container references", 
        "...  no blessing of any of the data wrapped..."

<DT>    <a href="http://search.cpan.org/perldoc?Class%3A%3AStd"
            class="podlinkpod"">Class::Std</a> 
<DD>    The canonical inside-out (flyweight object) base class. Unmaintained.

<DT>    <a href="http://search.cpan.org/perldoc?Class%3A%3AInsideOut"
            class="podlinkpod"">Class::InsideOut</a> 
<DD>    Robust but minimal inside-out objects. Generates accessors 
        and <TT>DESTROY</TT> method.

<DT>    <a href="http://search.cpan.org/perldoc?UNIVERSAL"
            class="podlinkpod"">UNIVERSAL</a> 
<DD>    Don't forget that all classes always inherit from UNIVERSAL, which 
        provides <TT>isa()</TT>, <TT>can()</TT>, <TT>DOES()</TT>, 
        and <TT>VERSION()</TT>.

</DL>

=end html

=head1 INSTALLATION

This module is installed using L<< Module::Build|Module::Build >>. 

=head1 DIAGNOSTICS

Generates no diagnostics; any error you see is raised by perl itself.

=head1 CONFIGURATION AND ENVIRONMENT

None. 

=head1 DEPENDENCIES

There are no non-core dependencies. 

=begin html

<!--

=end html

L<< version|version >> 0.99 E<10> E<8> E<9>
Perl extension for Version Objects

=begin html

-->

<DL>

<DT>    <a href="http://search.cpan.org/perldoc?version" 
            class="podlinkpod">version</a> 0.99 
<DD>    Perl extension for Version Objects

</DL>

=end html

This module should work with any version of perl 5.8.8 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any issues to: 
L<< https://github.com/Xiong/devel-toolbox/issues >>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<< https://github.com/Xiong/devel-toolbox >>. 

=begin TODO 

=head1 THANKS

Somebody helped!

=end TODO

=head1 AUTHOR

Xiong Changnian  C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 
Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<< http://www.opensource.org/licenses/artistic-license-2.0.php >>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut





