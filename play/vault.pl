#!/usr/bin/env perl
#       play-2013.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib qw| lib |;
use Error::Base;                # Simple structured errors with full backtrace
use Perl6::Form;                # Flexibly formatted output
use Test::Trap;                 # Trap exit codes, exceptions, output, etc.
use Clone                       # Recursively copy Perl datatypes
    qw| clone |;
use Capture::Tiny               # Capture STDOUT and STDERR
    qw| :all |;

#~ use Devel::Comments '###';
use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#
#~ use Test::More tests => 2;
use Test::More;
sub vault (&$);      # forward
my $must_fail       = 1;

pass('First check always passes.');

# Checker vault, not case execution trap.
# Rationally, one check at a time, please.
# In this play script, should always be [not] ok 2.
my $rv  = vault {
#~     pass('Second check passing');       # Test::More::pass()
#~     fail('Second check failing');       # Test::More::fail()
#~     say 'ok 2 Second check';            # talking to STDOUT directly
    
} $must_fail;

### $rv

my $builder = Test::More->builder;
### BEFORE THIRD CHECK
### $builder


pass('Third check always passes.');
### AFTER THIRD CHECK
### $builder

done_testing;
#~ say STDOUT '===';
### AFTER DONE_TESTING
### $builder

#~ exit(0);
#----------------------------------------------------------------------------#

sub vault (&$) {
    my $coderef     = shift;
    my $must_fail   = shift;
    my $vault       = {};
    my $bldout      ;
    my @bldout      ;
    my $blderr      ;
    my $stdout      ;
    my @stdout      ;
    my $stderr      ;
    my $todo        ;
    my $plan        = '1..';    # fill in with count
    my $count       = 0;
    my $mario       ;           # clone of $builder
    
    
    # Clone/freeze Test::Builder.
    my $builder = Test::More->builder;
    $mario          = clone($builder);
    
    # Misdirect Test::Builder output.
    ### BEFORE MISDIRECT
    ### $builder
    ### $mario
#~     $builder->        output(\$bldout);
#~     $builder->failure_output(\$blderr);
#~     $builder->   todo_output(\$todo  );
    ### AFTER MISDIRECT
    ### $builder
    ### $mario
    
    
    # Actual execution of the checker...
    #   inside Capture::Tiny::capture{}
    (                           # returns positional results; don't alter
        $vault->{stdout},
        $vault->{stderr},
        $vault->{return},
    ) 
        = capture { &$coderef };
    
    ### AFTER CHECK
    ### $builder
    ### $mario
    
    
#~     if ($must_fail) {
#~         for (@stdout) {
#~             s/^not ok/Xok/;
#~             s/^ok/not ok/;
#~             s/^Xok/ok/;
#~         };
#~         ### AFTER MUST FAIL
#~         ### @stdout
#~         $stdout     = join qq{\n}, @stdout;
#~         $stderr     = '#   Check was declared to fail.';
#~     }
#~     else {
#~         $stdout     = join qq{\n}, @stdout;
#~     };
    
    
    # Restore Test::Builder.
#~     $Test::Builder::Test    = $mario;   # fuck with actual package variable
#~     $builder->reset_outputs;
    ### AFTER RESTORE
    ### $builder
    
    # Do the fake check to stand in for the real check we just hid.
#~     pass('Fake second check.');
    
#~     say STDOUT $stdout;
#~     say STDERR $stderr;
#~     say STDOUT $plan;
    
#~     # Store for later amusement. 
#~     $vault->{stdout}    = $stdout;
#~     $vault->{stderr}    = $stderr;
#~     $vault->{todo}      = $todo;
    
    return $vault;
};


#============================================================================#
__END__     
