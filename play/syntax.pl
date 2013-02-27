#!/usr/bin/env perl
#       syntax.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
use Error::Base;

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
say "$0 Running...";

use Declare;

sub fiddle;                 # forward
declare {
        -foo    => 'bar',
        -hoge   => 'piyo',
        -name   => 'fiddle',
        -coderef    => 
sub{
    say '----Hey!';
}}; ## fiddle

sub wonk {
    &$fiddle;
};


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

#----------------------------------------------------------------------------#



#============================================================================#
__END__     
