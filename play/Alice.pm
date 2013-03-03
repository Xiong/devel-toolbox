package Alice;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
use Sub::Exporter -setup => {
    exports     => [qw( run )],
#~     into_level  => 1,
    groups      => { default => ['run'] },
};

sub run {
    say 'Runs.';
};

1;
