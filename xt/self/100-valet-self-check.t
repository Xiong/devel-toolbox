package Acme::Teddy;
{
    sub roar {
        'Roar!'
    };
}

package main;
use strict;
use warnings;

# Core modules
use lib qw| lib |;

# Project modules
use parent qw| Devel::Toolbox::Test::Valet |;

# Dummy testing target
use Acme::Teddy;

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

#----------------------------------------------------------------------------#
# Inits

my $self            = main->new();
$self->{script}     = 'valet-self-check';
#~ ### $self

#----------------------------------------------------------------------------#
# Declarations

# Declare checkers.
sub return_is { $_[0]->return_is( 0, $_[1], $_[2]) };
$self->{checker}{ return_is}    = \&return_is;

# Which cases to enforce?
        # =EITHER=
#~ $self->{enable}     = {
#~     null    => 1,
#~ };
        # =OR=
#~ $self->{enable}     = {
#~    ':all'   => 1,
#~     null    => 0,
#~ };

### $self

# Declare cases themselves.
#            {               }   #
$self->{case}{ null          }   = {
    sort    => 0,
    sub     => sub {  },
    args    => undef,
    want    => {
        return_is       => undef,
    },
};  ## case

$self->{case}{ teddy_roar     }   = {
    sort    => 1,
    sub     => sub {
        Acme::Teddy::roar();
    },
    args    => undef,
    want    => {
        return_is       => 'Roar!',
    },
};  ## case


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
