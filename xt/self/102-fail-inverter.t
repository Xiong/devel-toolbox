use strict;
use warnings;

# Core modules
use lib qw| lib |;

# Project modules
use Devel::Toolbox::Test::Valet; #High productivity testing: correct, complete

# Checkers are class methods defined in this __PACKAGE__ or inherited from...
use parent 'Devel::Toolbox::Test::Checker';

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

#----------------------------------------------------------------------------#
# Inits

my $self            = Devel::Toolbox::Test::Valet->new();
#~ ### $self

#----------------------------------------------------------------------------#
# Declarations

# Add attributes to specific cases and checks. 
$self->sort(qw|
    null
    no_args
    missing_ok
    simple
    
|);
$self->disable(qw|
    disable_me
|);

### $self

# Declare cases themselves.
$self->{case}{ null             }   = {
    sub     => undef,
    args    => undef,
    want    => {
        return_is       => undef,
        quiet           => 1,
    },
};  ##

$self->{case}{ no_args          }   = {
    sub     => \&Devel::Toolbox::Test::Valet::_fail_inverter,
    args    => undef,
    want    => {
        die_like        => qr/Checker error: Failed to emit any TAP/,
    },
};  ##

$self->{case}{ missing_ok       }   = {
    sub     => \&Devel::Toolbox::Test::Valet::_fail_inverter,
    args                    => [{
            out     => 'fok',
        
        }],
    want    => {
        die_like        => qr/Checker error: Failed to emit/,
        die_like        => qr/either 'ok' or 'not ok'/,
    },
};  ##

$self->{case}{ simple          }   = {
    sub     => \&Devel::Toolbox::Test::Valet::_fail_inverter,
    args                    => [{
        out         => 'ok',
        must_fail   => 0,
    }],
    want    => {
        return_is_deeply    => [{
            is_ok   => 1,
            diag    => '',
            
        }],
        quiet               => 1,
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
