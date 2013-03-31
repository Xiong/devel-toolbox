#!/usr/bin/env perl
#       play-2013.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib qw| lib |;
use Error::Base;
use Perl6::Form;
use Test::Trap;

#~ use Devel::Comments '###';
use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
use Test::More;
sub vault (&$);      # forward
my $must_fail       = 1;

my $rv  = vault {
    pass('I passed wrongly.');      # should fail
    fail('I failed correctly.');    # should pass
    
} $must_fail;

### $rv


#~ pass('The kids are alright.');      # should pass anyway
#~ done_testing;
exit(0);
#----------------------------------------------------------------------------#

sub vault (&$) {
    my $coderef     = shift;
    my $must_fail   = shift;
    my $vault       = {};
    my $stdout      ;
    my @stdout      ;
    my $stderr      ;
    my $todo        ;
    my $plan        = '1..';    # fill in with count
    my $count       = 0;
    
    my $builder = Test::More->builder;
    ### BEFORE DIDDLE
    ### $builder
    
    $builder->        output(\$stdout);
    $builder->failure_output(\$stderr);
    $builder->   todo_output(\$todo  );
    ### AFTER DIDDLE
    ### $builder
    
    $vault->{return}    = &$coderef;
    
    say q{};
    @stdout         = split /\n/, $stdout;
    $count          = scalar @stdout;
    $plan .= $count;
    ### $must_fail
    ### @stdout
    ### $count
    ### $plan
    
    if ($must_fail) {
        for (@stdout) {
            s/^not ok/Xok/;
            s/^ok/not ok/;
            s/^Xok/ok/;
        };
        ### AFTER MUST FAIL
        ### @stdout
        $stdout     = join qq{\n}, @stdout;
        $stderr     = '#   Check was declared to fail.';
    }
    else {
        $stdout     = join qq{\n}, @stdout;
    };
    say STDOUT $stdout;
    say STDERR $stderr;
    say STDOUT $plan;
    
    $vault->{stdout}    = $stdout;
    $vault->{stderr}    = $stderr;
    $vault->{todo}      = $todo;
    
    return $vault;
};


#============================================================================#
__END__     
