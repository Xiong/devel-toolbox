#!/usr/bin/env perl
#       syntax.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'lib';
use Error::Base;

use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

say "$0 Running...";

using Foo;

my $self    = Foo->new({
                    -attr   => 'value',
                });
### $self

#~ $self->munge();
#~ $self->::munge();
#~ $self->Foo::munge();
#~ $self->Screw::you();
#~ $self-> ::munge();
$self-> DT::munge();

### $self;


#~ ::munge($self);
::Foo::munge($self);

### $self;

say "Done.";
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

sub using {
    say 'Tricky stuff here.';
    sub DT::munge { munge(@_) };
};

__END__     
