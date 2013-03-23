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
$self->{checker}{ return    }
    = sub { $_[0]->return_is( 0, $_[1], $_[2]) };

# Which cases to enforce?
$self->enable ({
    null    => 1,
});
#~ ### $self

# Declare cases themselves.
#            {               }   #
$self->{case}{ null          }   = {
    sort    => 0,
    sub     => sub {  },
    args    => undef,
    want    => {
        return  => undef,
    },
};  ## case

$self->{case}{ teddy_roar     }   = {
    sort    => 1,
    sub     => sub {
        Acme::Teddy::roar();
    },
    args    => undef,
    want    => {
        return  => 'Roar!',
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
