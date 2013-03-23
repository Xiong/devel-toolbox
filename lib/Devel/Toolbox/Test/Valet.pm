package Devel::Toolbox::Test::Valet;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib qw| lib |;
use Test::More;

# CPAN modules

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
# Pseudo-globals



## pseudo-globals
#----------------------------------------------------------------------------#

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub enforce {
    my $self        = shift;  
    my $cases       = $self->{case} // die "No test cases declared.";
    
    for my $case ( keys $cases ) {
        my $diag    = $self->{script} . q{ };
        
        
        $self->{check_count}++;
        $diag   .= 'case_complete';
        pass($diag);
    };
    
    return $self;
}; ## enforce

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub enable {
    my $self        = shift;  
    
    
    return $self;
}; ## enable

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub finish {
    my $self        = shift; 
    ### $self
     
    done_testing( $self->{check_count} );
    
    exit;       # NEVER RETURNS
}; ## finish

#=========# CLASS METHOD
#~ my $self    = Devel::Toolbox::Core::Base->new({
#~                 -key        => 'value',
#~             });
#
#   Classic hashref-based-object constructor.
#   
sub new {
    my $class   = shift;
    my $self    = {};
    bless ( $self => $class );
    $self->init(@_);                            # init remaining args
    return $self;
}; ## new

#=========# OBJECT METHOD
#~ $self->init({
#~     -key        => 'value',
#~ });
#
#   Standard hashref-merge initializer. 
#   New values overwrite old values without touching other attributes.
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

Devel::Toolbox::Test::Valet - High productivity testing: correct, complete

=head1 VERSION

This document describes Devel::Toolbox::Test::Valet version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Test::Valet;

=head1 DESCRIPTION

=over

I<A knight in shining armor has never had his mettle truly tested. > 
-- some meme

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

  C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 
 C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut





