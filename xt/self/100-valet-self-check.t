use strict;
use warnings;

# Core modules
use lib qw| lib |;

# Project modules
use parent qw| Devel::Toolbox::Test::Valet |;

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

#----------------------------------------------------------------------------#
# inits

my $self            = main->new();
$self->{script}     = 'valet-self-check';
#~ ### $self

#----------------------------------------------------------------------------#
# case declarations

$self->enable ({
    null    => 1,
});
#~ ### $self

#            {               }   #
$self->{case}{ null          }   = {
    code    => sub {  },
    args    => undef,
    want    => {
        return  => undef,
    },
};
### $self

#----------------------------------------------------------------------------#
# execute and check

$self->enforce();
### $self

#----------------------------------------------------------------------------#
# cleanup

END {
    $self->finish();     # exits
}
exit;
#============================================================================#
