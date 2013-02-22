#!/usr/bin/env perl
#       mice.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'lib';
use Error::Base;

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

say "[$0] Running...";
use Devel::Toolbox;             # Simple custom project tool management
#~ use parent 'Devel::Toolbox::Core::Base';
use Devel::Toolbox::Set::Dog;

my $self    = Devel::Toolbox::Core::Base->new();
#~ my $self    = main->new();

say "[$0] (dog bark) YES";
$self->Devel::Toolbox::Set::Dog::bark();    # should work; Dog claims Cat

say "[$0] (self meow) YES";
$self->meow();                              # should work; $self is blessed

#~ say "[$0] (main meow) NO";
#~ meow();                                     # should not work
#~                                             #  because clean main namespace

say "[$0] Done.";
exit 0;

#----------------------------------------------------------------------------#

sub munge {
    my $self        = shift;
    $self->{-attr}  = reverse $self->{-attr};
    return $self;
};

sub Screw::you {
    my $self        = shift;
    $self->{-attr}  = 'flipt';
    return $self;
};

#----------------------------------------------------------------------------#
package Foo;


sub new {
    my $class   = shift;
    my $self    = {};           # always hashref
    
    bless ($self => $class);
    $self->init(@_);            # init remaining args
    
    return $self;
}; ## new

sub init {
    my $self        = shift;
    my $args        = shift;
    %{$self}        = ( %{$self}, %{$args} );
    return $self;
}; ## init

sub munge { ::munge(@_); };

__END__     
