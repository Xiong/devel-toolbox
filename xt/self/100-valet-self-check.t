package Acme::Teddy;
{
    sub roar        { return        'Roar!' };
    sub roar_out    { print         'Roar!' };
    sub roar_err    { print STDERR  'Roar!' };
    sub roar_die    { die           'Roar!' };
}

package main;
use strict;
use warnings;

# Core modules
use lib qw| lib |;

# Project modules
use Devel::Toolbox::Test::Valet;
use parent 'Devel::Toolbox::Test::Checker';

# Dummy testing target
use Acme::Teddy;

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

#----------------------------------------------------------------------------#
# Inits

my $self            = Devel::Toolbox::Test::Valet->new();
$self->{script}     = 'valet-self-check';
#~ ### $self

#----------------------------------------------------------------------------#
# Declarations

# Override checkers.
# $_[0]: Checker class, usually 'main' (caller).
#               $_[1]                $_[2]  $_[3]
#   {check()}   $trap (have)         {want} {diag}
sub return_is { $_[1]->return_is( 0, $_[2], $_[3]) };

# Which cases to enforce?
        # =EITHER=
#~ $self->{enable} = {
#~     undeclared_case => 1,
#~ };
        # =OR=
#~ $self->{enable} = {
#~    ':all'       => 1,
#~     undeclared_case => 0,
#~ };

### $self

# Declare cases themselves.
$self->{case}{ empty_hashref    }   = {};

$self->{case}{ null             }   = {
    sort    => 1,
    sub     => sub {  },
    args    => undef,
    want    => {
        return_is       => undef,
        quiet           => 1,
    },
};  ## case

$self->{case}{ roar             }   = {
    sort    => 2,
    sub     => sub {
        Acme::Teddy::roar();
    },
    args    => undef,
    want    => {
        return_is       => 'Roar!',
        quiet           => 1,
    },
};  ## case

$self->{case}{ roar_out         }   = {
    sort    => 3,
    sub     => sub {
        Acme::Teddy::roar_out();
    },
    args    => undef,
    want    => {
        return_is       => 1,       # print returns true if successful
        stdout_is       => 'Roar!',
    },
};  ## case

$self->{case}{ roar_err         }   = {
    sort    => 3,
    sub     => sub {
        Acme::Teddy::roar_err();
    },
    args    => undef,
    want    => {
        return_is       => 1,
        stderr_is       => 'Roar!',
    },
};  ## case

$self->{case}{ roar_die         }   = {
    sort    => 3,
    sub     => sub {
        Acme::Teddy::roar_die();
    },
    args    => undef,
    want    => {
        died            => 1,
        die_like        => qr/^Roar! at/,
    },
};  ## case

#            {                  }   = #


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
