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
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~
use Devel::Comments '####', ({ -file => 'debug.log' });                  #~

## use
#============================================================================#
#~ use Test::More tests => 2;
use Test::More;
sub vault (&$);      # forward
my $dummy = trap{ 
    1;                  # target execution for Test::Trap
};

#~ my $must_fail       = 1;
my $must_fail       = 0;

pass('First check always passes.');

# Checker vault, not case execution trap.
# Rationally, one check at a time, please.
# In this play script, should always be [not] ok 2.
my $rv  = vault {
#~     say 'ok 2 [say] Second check passing';      # talking to STDOUT directly
#~     say 'not ok 2 [say] Second check failing';  # talking to STDOUT directly
#~     say STDERR '%# My funky diagnostic?';
#~     pass('[TM] Second check passing');          # Test::More::pass()
#~     fail('[TM] Second check failing');          # Test::More::fail()
#~     $trap->did_return('[TT] did_return');       # Test::Trap
    $trap->did_die('[TT] did_die');             # Test::Trap
    
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
    my $return      ;
    my $out         ;
    my $err         ;
    my $todo        ;
    my $plan        = '1..';    # fill in with count
    my $count       = 0;
    my $mario       ;           # clone of $builder
    my $report      ;
    my @report      ;
    my $diag        ;
    my $diag_recon  ;
    my $is_ok       ;
    my $original_report ;
    my $report_prepend  = qq{| ACTUAL:\n};
    my $report_indent   =  q{|};
    my $report_bad      = qq{| This check must fail but did not (BAD).\n};
    my $report_good     = qq{| This check must fail and did (GOOD).\n};
    
    
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
        $stdout,
        $stderr,
        $return,
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
    
    ### $bldout
    ### $stdout
    
    # Consolidate outputs; these may come from four sources.
    $out        = defined $bldout   ? $bldout 
                : defined $stdout   ? $stdout 
                :                     die "! Failed to capture (STD)OUT."
                ;
    chomp $out;
    $err        = defined $blderr   ? $blderr 
                : defined $stderr   ? $stderr 
                :                     undef
                ;
    
    ### $must_fail
    ### $err
    
    # Compose any diagnostic message. 
    #   If not $must_fail, it should be just as it was ($err only).
    #   If $must_fail, it should include both $out and $err and be marked.
    #   If $err is empty, then no diagnostic was emitted; 
    #       say so only if $must_fail.
    my $M   = $must_fail    ? 'M1' : 'M0';
    my $E   = $err          ? 'E1' : 'E0';
    {
        no warnings 'uninitialized';
        chomp $err;
        $err =~ s/^# //gm;              # Test::More will replace octothorpes
        $original_report 
            = join qq{\n}, map { $report_indent . $_ }
                split qq{\n}, join  qq{\n}, ( $out, $err );
        chomp $original_report;
    }
    my %report_for  = (
        M0_E0   => undef,               # normal passing check; be silent
        M0_E1   => $err,                # normal failing check; echo
        M1_E0   => $report_bad          # must fail and did NOT fail
                .  $report_prepend
                .  $original_report
                ,
        M1_E1   => $report_good         # must fail and did fail...
                .  $report_prepend
                .  $original_report
                ,
    ); ## report_for
    $report     = $report_for{ join q{_}, $M, $E };
    
    # Invert sense of test if demanded to fail; also always extract... 
    # ... original $diag or test name portion from intercepted outputs.
    my $invert_hrf      = Devel::Toolbox::Test::Valet::_fail_inverter({
        out         => $out,
        must_fail   => $must_fail,
    });
    $is_ok      = $invert_hrf->{is_ok}; # pass or fail if it should have done
    $diag_recon = $invert_hrf->{diag};  # original test name
    
    {
        # Attempt to force the report from the correct (topmost) caller frame. 
        local $Test::Builder::Level = $Test::Builder::Level + 9;
        
        # Do the fake check to stand in for the real check we just hid.
        ok( $is_ok, $diag_recon);
    }
    
    # Print diagnostics, such as they may be.
    if ( defined $report ) {
        note($report);
    };
    
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
    $vault->{return}        = $return;
    $vault->{out}           = $out;
    $vault->{err}           = $err;
    $vault->{todo}          = $todo;
    
    return $vault;
};


#============================================================================#
__END__     
