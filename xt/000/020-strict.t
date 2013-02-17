# This test should demonstrate that strictures are enabled
#   in all lexical scope in this project. 
#   But it only checks use-ed modules. 

#~ use strict;
use warnings;

my @modules     = (
    'Devel::Toolbox',             # Simple custom project tool management
    'Devel::Toolbox::Set::New',   # Create a project, module, test, or toolset

);

BEGIN {
#~     no warnings 'redefine';
    require strict;
    no warnings;
    *strict::import = sub {
        my @caller      = caller(0);
        my $call_pkg    = $caller[0];
        push @::callers, $call_pkg;
    };
}

use Test::More;
my $tc      ;
my $base    = 'strictures-enabled: ';

for (@modules) {
    $tc++;
    my $mod     = $_;
    my $diag    = $base . $mod;
    eval "use $mod";
    my $got     = join q{^}, @::callers;
    my $want    = qr/$mod/;
    like( $got, $want, $diag );
};

done_testing($tc);
exit 0;


