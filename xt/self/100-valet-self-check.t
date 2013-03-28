package Acme::Teddy;
{
    sub roar {
        return 'Roar!'
    };
    sub roar_out {
        print 'Roar!'
    };
    sub roar_err {
        print STDERR 'Roar!'
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
#~     re_enter        => 1,
#~ };
        # =OR=
#~ $self->{enable} = {
#~    ':all'       => 1,
#~     undeclared_case => 0,
#~     bad_checker     => 0,
#~     re_enter        => 0,
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

$self->{case}{ teddy_roar       }   = {
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

$self->{case}{ teddy_roar_out   }   = {
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

$self->{case}{ teddy_roar_err   }   = {
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
