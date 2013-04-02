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
use Devel::Toolbox::Test::Valet; #High productivity testing: correct, complete

#~ use Devel::Comments '###';
use Devel::Comments '###', ({ -file => 'debug.log' });                   #~
#~ use Devel::Comments '####', ({ -file => 'debug.log' });                  #~

## use
#============================================================================#
#~ use Test::More tests => 2;
use Test::More;
sub vault (&$);      # forward
#~ my $must_fail       = 1;
my $must_fail       = 0;

my $dummy = trap{ 
    1;
};

pass('First check always passes.');

# Checker vault, not case execution trap.
# Rationally, one check at a time, please.
# In this play script, should always be [not] ok 2.
my $rv  = vault {
#~     say 'ok 2 [say] Second check';          # talking to STDOUT directly
#~     pass('[TM] Second check passing');      # Test::More::pass()
#~     fail('[TM] Second check failing');      # Test::More::fail()
#~     $trap->did_return('[TT] did_return');   # Test::Trap
    $trap->did_die('[TT] did_die');         # Test::Trap
    
} $must_fail;

### $rv

my $builder = Test::More->builder;
#### BEFORE THIRD CHECK
#### $builder


pass('Third check always passes.');
#### AFTER THIRD CHECK
#### $builder

done_testing;

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
    my $out         ;
    my $err         ;
    my $todo        ;
    my $plan        = '1..';    # fill in with count
    my $count       = 0;
    my $mario       ;           # clone of $builder
    my $report      ;
    my $diag        ;
    my $diag_recon  ;
    
    
    # Clone/freeze Test::Builder.
    my $builder = Test::More->builder;
    $mario          = clone($builder);
    
    # Misdirect Test::Builder output.
    #### BEFORE MISDIRECT
    #### $builder
    #### $mario
    $builder->        output(\$bldout);
    $builder->failure_output(\$blderr);
    $builder->   todo_output(\$todo  );
    #### AFTER MISDIRECT
    #### $builder
    #### $mario
    
    
    # Actual execution of the checker...
    #   inside Capture::Tiny::capture{}
    (                           # returns positional results; don't alter
        $vault->{stdout},
        $vault->{stderr},
        $vault->{return},
    ) 
        = capture { &$coderef };
    
    #### AFTER CHECK
    #### $builder
    #### $mario
    
    
    
    # Restore Test::Builder.
    $Test::Builder::Test    = $mario;   # fuck with actual package variable
#~     $builder->reset_outputs;
    #### AFTER RESTORE
    #### $builder
    
    # Consolidate outputs; these may come from four sources.
    $out        = ( defined $bldout ? $bldout : q{} )
                . ( defined $stdout ? $stdout : q{} )
                ;
    $err        = ( defined $blderr ? $blderr : q{} )
                . ( defined $stderr ? $stderr : q{} )
                ;
    $report     = ( defined $out    ? $out    : q{} )
                . ( defined $err    ? $err    : q{} )
                ;
    
    # Invert sense of test if demanded to fail; anyway always... 
    # extract original '$diag' or test name portion from intercepted outputs.
    my $invert_hrf      = Devel::Toolbox::Test::Valet::_fail_inverter({
        out     => $out,
        err     => $err,
        must_fail   => $must_fail,
    });
    $out        = $invert_hrf->{out};
    $err        = $invert_hrf->{err};
    $diag_recon = $invert_hrf->{diag};
    
    # Do the fake check to stand in for the real check we just hid.
    if ($must_fail) {
        fail($diag_recon);
    }
    else {
        pass($diag_recon);
    };
    
    # Print the actual results of the check.
    $diag       = "Actual check report: $report";
    note($diag);
    
    
#~     say STDOUT $stdout;
#~     say STDERR $stderr;
#~     say STDOUT $plan;
    
    # Store for later amusement. 
    $vault->{report}        = $report;
    $vault->{diag_recon}    = $diag_recon;
    $vault->{bldout}        = $bldout;
    $vault->{blderr}        = $blderr;
    $vault->{stdout}        = $stdout;
    $vault->{stderr}        = $stderr;
    $vault->{out}           = $out;
    $vault->{err}           = $err;
    $vault->{todo}          = $todo;
    
    return $vault;
};


#============================================================================#
__END__     
