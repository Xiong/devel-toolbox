use strict;
use warnings;

# Core modules
use lib qw| lib |;

# Project modules
use parent qw| Devel::Toolbox::Test::Valet |;

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

#----------------------------------------------------------------------------#
# Inits

my $self            = main->new();
$self->{script}     = 'valet-self-check';
#~ ### $self

#----------------------------------------------------------------------------#
# Declarations

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

$self->{case}{ enforce_null     }   = {
    sort    => 1,
    sub     => sub {
        my $s   = main->new();
        $s->enforce();
    },
    args    => undef,
    want    => {
        return  => undef,
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
