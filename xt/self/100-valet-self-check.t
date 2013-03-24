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
# 
# Example checker uses Test::Trap method.
#   {check}     {trap}               {want} {diag}
sub return_is { $_[1]->return_is( 0, $_[2], $_[3]) };

# Which cases to enforce?
        # =EITHER=
#~ $self->{enable} = {
#~     null            => 1,
#~ };
        # =OR=
$self->{enable} = {
   ':all'       => 1,
    bad_checker     => 0,
};

### $self

# Declare cases themselves.
#            {                  }   = #
$self->{case}{ null             }   = {
    sort    => 0,
    sub     => sub {  },
    args    => undef,
    want    => {
        return_is       => undef,
    },
};  ## case

$self->{case}{ bad_checker      }   = {
    sort    => 0,
    sub     => sub {  },
    args    => undef,
    want    => {
        bad_checker     => undef,
    },
};  ## case

$self->{case}{ teddy_roar       }   = {
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
