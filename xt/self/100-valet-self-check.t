package Acme::Teddy;
{
    sub roar        { return        'Roar!'             };
    sub roar_out    { print         'Roar!'             };
    sub roar_err    { print STDERR  'Roar!'             };
    sub roar_die    { die           'Roar!'             };
    
    sub tree        { return { a => [ 7, 'bar', 2 ] }   };
}

package main;
use strict;
use warnings;

# Core modules
use lib qw| lib |;

# Project modules
use Devel::Toolbox::Test::Valet;

# Checkers are class methods defined in this __PACKAGE__ or inherited from...
use parent 'Devel::Toolbox::Test::Checker';

# Dummy testing target
use Acme::Teddy;

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

#----------------------------------------------------------------------------#
# Inits

my $self            = Devel::Toolbox::Test::Valet->new();
#~ ### $self

#----------------------------------------------------------------------------#
# Declarations

# Declare, possibly override checkers.
# $_[0]: Checker class, usually 'main' (caller).
#               $_[1]                $_[2]  $_[3]
#   {check()}   $trap (have)         {want} {diag}
sub return_is { $_[1]->return_is( 0, $_[2], $_[3]) };

# Add attributes to specific cases and checks. 
$self->sort(qw|
    empty_hashref
    null
    roar
    roar_out
    roar_err
    roar_die
    tree
|);
$self->disable(qw|
    disable_me
|);

### $self

# Declare cases themselves.
$self->{case}{ empty_hashref    }   = {};

$self->{case}{ null             }   = {
    sub     => undef,
    args    => undef,
    want    => {
        return_is       => undef,
        quiet           => 1,
    },
};  ##

$self->{case}{ roar             }   = {
    sub     => sub {
        Acme::Teddy::roar();
    },
    args    => undef,
    want    => {
        return_is       => 'Roar!',
        quiet           => 1,
    },
};  ##

$self->{case}{ roar_out         }   = {
    sub     => sub {
        Acme::Teddy::roar_out();
    },
    args    => undef,
    want    => {
        return_is       => 1,       # print returns true if successful
        stdout_is       => 'Roar!',
    },
};  ##

$self->{case}{ roar_err         }   = {
    sub     => sub {
        Acme::Teddy::roar_err();
    },
    args    => undef,
    want    => {
        return_is       => 1,
        stderr_is       => 'Roar!',
    },
};  ##

$self->{case}{ roar_die         }   = {
    sub     => sub {
        Acme::Teddy::roar_die();
    },
    args    => undef,
    want    => {
        died            => 1,
        die_like        => qr/^Roar! at/,
    },
};  ##

$self->{case}{ tree             }   = {
    sub     => sub {
        Acme::Teddy::tree();
    },
    args    => undef,
    want    => {
        return_is_deeply    => [        # always want the whole array
            { a => [ 7, 'bar', 2 ] }
        ],
        quiet               => 1,
    },
};  ##

$self->{case}{ disable_me       }   = {
    sub     => sub { 1 },
    args    => undef,
    want    => {
        return_is       => undef,   # would fail
    },
};  ##

#            {                  }   = # formatting guide


### $self

#----------------------------------------------------------------------------#
# Execute and check

$self->enforce();
### $self

#----------------------------------------------------------------------------#
# Cleanup

END {
    $self->finish();     # exits
}
exit;
#============================================================================#
