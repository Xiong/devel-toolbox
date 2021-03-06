package Devel::Toolbox::Test::Valet;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

# Core modules
use lib qw| lib |;
use Test::More;

# CPAN modules
use Test::Trap;                 # Trap exit codes, exceptions, output, etc.
use List::MoreUtils             # The stuff missing in List::Util
    qw| any |;
use Clone                       # Recursively copy Perl datatypes
    qw| clone |;
use Capture::Tiny               # Capture STDOUT and STDERR
    qw| :all |;

# Project modules
use parent 'Devel::Toolbox::Core::Base';

# Alternate uses
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~
#~ use Devel::Comments '###', '####', ({ -file => 'debug.log' });           #~
#~ use Devel::Comments '#####', ({ -file => 'debug.log' });                 #~
### DTT-VALET

## use
#============================================================================#
# Pseudo-globals



## pseudo-globals
#----------------------------------------------------------------------------#
# FORWARD DECLARATIONS
sub _ex;            # wrap around die() using Error::Base::crash()
sub _vault (&$);    # execute checks and *don't* emit TAP

#----------------------------------------------------------------------------#
# EXECUTION

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub enforce {
    my $self        = shift;  
    my $case        = $self->{case}         // _ex "No cases declared.";
#~     my $caller_script   = $self->{attr}{caller_script};
    my $caller_package  = $self->{attr}{caller_package};
    my $attr        = $self->{attr};
    my @case_keys   = keys $case;
    
#~ # DEBUG ONLY
#~ my $builder;
#~ $builder = Test::More->builder;
#~ ##### enforce ENTRY
#~ ##### $builder
    
    # Ignore disabled cases.
    @case_keys      = grep { $self->_is_enabled($_) } @case_keys;
    
    # A case hash is declared but let us enforce cases in predictable order.
    # You can alter this order by calling $self->sort(@keys)
    @case_keys      = $self->_do_sort( @case_keys );
    
    # Unpack case, execute, check.
    CASE_KEY:
    for my $case_key ( @case_keys ) {
        my $extra       ;
        my $diag        ;
        note( "---- $case_key:" );
        my $i_case        = $case->{$case_key};
        my $context     = uc( $i_case->{context}  // 'SCALAR' );   # VOID, ARRAY
        my @args        = @{ $i_case->{args}      // []       };
        my $sub         = $i_case->{sub}          // 0        ;
        
        # Skip case if no code defined, eh.
        if ( not $sub ) {
            pass _append( $case_key, 'Skipped, no {sub} defined.' );
            next CASE_KEY;
        };
        
        # Invert operation; ok => not ok, not ok => ok
        if ( $self->_is_mustfail($case_key) ) {
            Test::More->builder->todo_start('MUSTFAIL');
        };
        # Execute code under test.
        given ($context) {
            when ( /VOID/   ) {
                             trap { &{ $i_case->{sub} }( @args ) };
            }
            when ( /ARRAY/  ) {
                my @array  = trap { &{ $i_case->{sub} }( @args ) };
            }
            when ( /SCALAR/ ) {
                my $scalar = trap { &{ $i_case->{sub} }( @args ) };
            }
            default         {
                _ex "Invalid context demanded: $context";
            }
        };
        
        # Store for possible later examination.
        $self->{case}{$case_key}{trap}      = $trap;
        
        # Do all checks for this case (as a subtest).
        subtest $case_key => sub {
            pass('execute');
            my $want        = $i_case->{want}     // {};
            if ( not $want ) {
                note _append( $case_key, 'Skipped, no {want} defined.' );
                done_testing(1);                # 1 subtest for 'execute'
                return;
            };
            CHECK_KEY:
            for my $check_key ( keys $want ) {
                ### enforce CHECK_KEY
                ### $case_key
                ### $check_key
#~                 ### $want
                $caller_package->$check_key(    # $_[0]     class, discard
                    $trap,                      # $_[1]     have
                    $want->{$check_key},        # $_[2]     want
                    $check_key,                 # $_[3]     diag
                ); ## some checker 
            }; ## for check
        }; ## subtest
        
        # Restore normal operation if we inverted it.
        if ( $self->_is_mustfail($case_key) ) {
            Test::More->builder->todo_end;
        };
    }; ## for i_case
    
    return $self;
}; ## enforce

#    #=========# INTERNAL ROUTINE
#    #~ 
#    #
#    #   @
#    #   
#    sub _vault (&$) {
#        my $coderef     = shift;
#        my $must_fail   = shift;
#        my $bldout      ;
#        my @bldout      ;
#        my $blderr      ;
#        my $stdout      ;
#        my @stdout      ;
#        my $stderr      ;
#        my $return      ;
#        my $out         ;
#        my $err         ;
#        my $todo        ;
#        my $plan        = '1..';    # fill in with count
#        my $count       = 0;
#        my $mario       ;           # clone of $builder
#        my $report      ;
#        my @report      ;
#        my $diag        ;
#        my $diag_recon  ;
#        my $is_ok       ;
#        my $original_report ;
#        my $report_prepend  = qq{| ACTUAL:\n};
#        my $report_indent   =  q{|};
#        my $report_bad      = qq{| This check must fail but did not (BAD).\n};
#        my $report_good     = qq{| This check must fail and did (GOOD).\n};
        
        
#        # Clone/freeze Test::Builder.
#        my $builder = Test::More->builder;
#        $mario          = clone($builder);
        
#        # Misdirect Test::Builder output.
#        #### BEFORE MISDIRECT
#        #### $builder
#        $builder->        output(\$bldout);
#        $builder->failure_output(\$blderr);
#        $builder->   todo_output(\$todo  );
#        #### AFTER MISDIRECT
#        #### $builder
        
        
#        # Actual execution of the checker...
#        #   inside Capture::Tiny::capture{}
#        (                           # returns positional results; don't alter
#            $stdout,
#            $stderr,
#            $return,
#        ) 
#            = capture { &$coderef };
        
#        #### AFTER CHECK
#        #### $builder
        
#        # Restore Test::Builder.
#        $Test::Builder::Test    = $mario;   # fuck with actual package variable
#        $builder->reset_outputs;
#        #### AFTER RESTORE
#        #### $builder
        
#    #~     ### $bldout
#    #~     ### $stdout
        
#        # Consolidate outputs; these may come from four sources.
#        $out        = defined $bldout   ? $bldout 
#                    : defined $stdout   ? $stdout 
#                    :                     die "! Failed to capture (STD)OUT."
#                    ;
#        chomp $out;
#        $err        = defined $blderr   ? $blderr 
#                    : defined $stderr   ? $stderr 
#                    :                     undef
#                    ;
        
#    #~     ### $must_fail
#    #~     ### $out
#    #~     ### $err
        
#        # Compose any diagnostic message. 
#        #   If not $must_fail, it should be just as it was ($err only).
#        #   If $must_fail, it should include both $out and $err and be marked.
#        #   If $err is empty, then no diagnostic was emitted; 
#        #       say so only if $must_fail.
#        my $M   = $must_fail    ? 'M1' : 'M0';
#        my $E   = $err          ? 'E1' : 'E0';
#        {
#            no warnings 'uninitialized';
#            chomp $err;
#            $err =~ s/^# //gm;              # Test::More will replace octothorpes
#            $original_report 
#                = join qq{\n}, map { $report_indent . $_ }
#                    split qq{\n}, join  qq{\n}, ( $out, $err );
#            chomp $original_report;
#        }
#        ### $original_report
#        my %report_for  = (
#            M0_E0   => undef,               # normal passing check; be silent
#            M0_E1   => $err,                # normal failing check; echo
#            M1_E0   => $report_bad          # must fail and did NOT fail
#                    .  $report_prepend
#                    .  $original_report
#                    ,
#            M1_E1   => $report_good         # must fail and did fail...
#                    .  $report_prepend
#                    .  $original_report
#                    ,
#        ); ## report_for
#        $report     = $report_for{ join q{_}, $M, $E };
        
#        # Invert sense of test if demanded to fail; also always extract... 
#        # ... original $diag or test name portion from intercepted outputs.
#        my $invert_hrf      = Devel::Toolbox::Test::Valet::_fail_inverter({
#            out         => $out,
#            must_fail   => $must_fail,
#        });
#        $is_ok      = $invert_hrf->{is_ok}; # pass or fail if it should have done
#        $diag_recon = $invert_hrf->{diag};  # original test name
        
#        {
#            # Attempt to force the report from the correct (topmost) caller frame. 
#            local $Test::Builder::Level = $Test::Builder::Level + 9;
            
#            # Do the fake check to stand in for the real check we just hid.
#            ok( $is_ok, $diag_recon);
#        }
        
#        # Print diagnostics, such as they may be.
#        if ( defined $report ) {
#            note($report);
#        };
        
#        # Store for later amusement.                # DEBUG
#        my $vault               = {};
#        $vault->{report}        = $report;
#        $vault->{diag_recon}    = $diag_recon;
#        $vault->{bldout}        = $bldout;
#        $vault->{blderr}        = $blderr;
#        $vault->{stdout}        = $stdout;
#        $vault->{stderr}        = $stderr;
#        $vault->{return}        = $return;
#        $vault->{out}           = $out;
#        $vault->{err}           = $err;
#        $vault->{todo}          = $todo;
        
#    }; ## _vault


#----------------------------------------------------------------------------#
# FLAGGING / ATTRIBUTES

#=========# OBJECT METHOD
#~ 
#
#   Class-specific init. 
#   
sub init {
    my $self            = shift;
    my $caller_package  = caller(1);    # caller of new(), which calls init()
    my $caller_script   = $0;
#~     ### $caller_package
#~     ### $caller_script
    
    $self->{attr}{caller_package}   = $caller_package;
    $self->{attr}{caller_script}    = $caller_script;
    $self->SUPER::init(@_);             # does not consume any arguments
    
    return $self;
}; ## init

#=========# OBJECT METHOD
#~ 
#
#   Stashes a natural number to each argument, in order given.
#   
sub sort {
    my $self                        = shift;
    my @args                        = @_;
    $self->{attr}{sort}             = {};
    
    # Iterate explicitly because we assign the index value.
    for my $i ( 0..$#args ) {
        $self->{attr}{sort}{ $args[$i] }    = $i;
    };
    
    return $self;
}; ## sort

#=========# INTERNAL OBJECT METHOD
#~ 
#
#   Just sorts a list, working from the {sort} cheat sheet if possible.
#   $self->{attr}{sort} may contain anything or nothing, or not be defined.
#   Performs a Tcl 'dictionary'-like sort:
#   Strings are sorted alphabetically, numbers sort numerically; 
#       and pseudos consisting of both kinds of parts are sorted. 
#   
#   See: $self->sort()
#   
sub _do_sort {
    my $self        = shift;
    my @list        = @_;
    my %sorta       = %{ $self->{attr}{sort} // {} };
    
    # Fill a hash cache completely.
    my %cache       = map {
        my $x   = $_;
        $x,           # key...
            $sorta{$x}      # ... get value from cheat sheet if defined
            //              # or pad numeric substrings with zeros to length 8
            lc $x =~ s/(\d+)/sprintf '%08d', $1/ger,
    } @list;
    
    @list           = sort { $cache{$a} cmp $cache{$b} } @list;
    
    return @list;
}; ## _do_sort

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub disable {
    my $self                        = shift;
    my @args                        = @_;
    $self->{attr}{disable}          = {};
    
    for my $i_arg (@args) {
        $self->{attr}{disable}{$i_arg} = 'DISABLE';     # TRUE if disabled
    };
    
    return $self;
}; ## disable

#=========# INTERNAL OBJECT METHOD
#~ 
#
#   @
#   
sub _is_enabled {
    my $self        = shift;
    my $key         = shift;
    my %disable     = %{ $self->{attr}{disable} // return 1 }; # enable all
    my $is_enabled  ;
    
    $is_enabled     = $disable{$key} ? 0 : 1;
    
    return $is_enabled;
}; ## _is_enabled

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub mustfail {
    my $self                        = shift;
    my @args                        = @_;
    $self->{attr}{mustfail}         = {};
    
    return if not @args;
    note('This script declares MUSTFAIL.');
    
    for my $i_arg (@args) {
        $self->{attr}{mustfail}{$i_arg} = 'MUSTFAIL';   # TRUE if mustfail
    };
    
    return $self;
}; ## mustfail

#=========# INTERNAL OBJECT METHOD
#~ 
#
#   @
#   
sub _is_mustfail {
    my $self        = shift;
    my $key         = shift;
    my %mustfail    = %{ $self->{attr}{mustfail} // return 0 }; # do not fail
    my $mustfail  ;
    
    $mustfail     = $mustfail{$key} ? 1 : 0;
    
    return $mustfail;
}; ## _is_mustfail

#=========# OBJECT METHOD
#=========# INTERNAL ROUTINE
#=========# EXTERNAL FUNCTION
#~ 
#
#   @
#   
sub _do_ {
    
    
    
}; ## _do_


#----------------------------------------------------------------------------#
# UTILITY

#=========# INTERNAL ROUTINE
#~ 
#
#   @
#   
sub _append {
#~     ### _append
#~     ### @_
    return join q{ | }, @_;
}; ## _append

#    #=========# INTERNAL ROUTINE
#    #~     my $hashref = _fail_inverter({
#    #~         out         => $string,     # captured (STD)OUT
#    #~         must_fail   => $bool,       # do you demand failure?
#    #~     });
#    #~     $bool   = $hashref->{is_ok};    # did the check do what was demanded?
#    #~     $string = $hashref->{diag};     # original test name
#    #
#    #   Execution flows through this routine on every check; 
#    #        it normally does little: a pass is a pass, and a fail is a fail. 
#    #   But when {must_fail} is TRUE, a pass is a fail, and a fail is a pass. 
#    #   
#    #   Captured TAP 'ok|not ok' output must be passed in.
#    #   As a convenience, the original check name is returned for re-emission.
#    #   
#    #   See also: Devel::Toolbox::Man::Test POD#PHILOSOPHY
#    #   
#    sub _fail_inverter {
#        my $args            = shift;
#        my $out             = $args->{out}          // # mandatory
#            _ex "Checker error: Failed to emit any TAP to (STD)OUT.";
#        my $must_fail       = $args->{must_fail}    // 0;
            
#        my $rh              = {};       # return hashref 
        
#        my $was_ok_str      ;           # what check actually emitted
#        my $was_ok_flag     ;           # bool
#        my $is_ok_flag      ;           # bool      our judgement
#        my $check_number    ;           # e.g., the '3' in 'ok 3'
#        my $diag            ;           # reconstructed test name or message
        
#        # Did the check say that it passed ('ok') or failed ('not ok')?
#        $out =~ s/^\s*(ok|not ok)//;
#        $was_ok_str         = $1
#            or _ex "Checker error: Failed to emit either 'ok' or 'not ok'";
#        $was_ok_flag        = $was_ok_str eq 'ok' ? 1 : 0;
        
#        # Extract check number and strip some rubbish.
#        $out =~ s/^\s*(\d*)\s*-?\s*//;  # strip e.g., ' 3 - '
#        $check_number       = $1;
        
#        # Extract directive. Whatever is left is the original $diag.
#        $out =~ s/#.*$//;               # drop all after first octothorpe
#        $diag   = $out;
#        chomp $diag;
        
#        # Append helpful explanation.
#        if ($must_fail) {
#            $diag   .= ' | MUST FAIL';
#        };
        
#        # Decide if this test REALLY passed or failed.
#        # TRUE if $must_fail is TRUE or $was_ok_flag is TRUE but not both!
#        $is_ok_flag         = ( $must_fail xor $was_ok_flag );
            
#        $rh->{is_ok}        = $is_ok_flag;
#        $rh->{diag}         = $diag;
#        return $rh;
#    }; ## _fail_inverter

#=========# INTERNAL ERROR WRAPPER ROUTINE
#~ 
#
#   Wraps die().
#   
sub _ex {
    require Error::Base;        # Simple structured errors with full backtrace
    Error::Base->crash(
        @_,
        -base       => 'DTT-Valet:',
        -prepend    => '! ',
        -nest       => 1,
    );
}; ## _ex

#----------------------------------------------------------------------------#
# CLEANUP

END {
    ### END BLOCK
    ### $?
    done_testing();
}

## END MODULE
1;
#============================================================================#
__END__

=head1 NAME

Devel::Toolbox::Test::Valet - High productivity testing: correct, complete

=head1 VERSION

This document describes Devel::Toolbox::Test::Valet version v0.0.0

=head1 SYNOPSIS

    use Devel::Toolbox::Test::Valet;

=head1 DESCRIPTION

=over

I< [Earl] Sidney Godolphin is never in the way, and never out of the way. >
-- Charles II L<^|http://www.bartleby.com/344/90.html>

=back

=head1 METHODS 

=head2 new()

=head1 ACCSESSORS

Object-oriented accessor methods are provided for each parameter and result. 
They all do just what you'd expect. 

    $self               = $self->put_attr($string);
    $string             = $self->get_attr();

=head1 SEE ALSO

L<Some::Module|Some::Module>

=head1 INSTALLATION

This module is installed using L<Module::Build|Module::Build>. 

=head1 DIAGNOSTICS

=over

=item C<< some error message >>

Some explanation. 

=back

=head1 CONFIGURATION AND ENVIRONMENT

None. 

=head1 DEPENDENCIES

There are no non-core dependencies. 

=over

=item 

L<version|version> 0.99    E<nbsp>E<nbsp>E<nbsp>E<nbsp> 
# Perl extension for Version Objects

=back

This module should work with any version of perl 5.16.2 and up. 
However, you may need to upgrade some core modules. 

=head1 INCOMPATIBILITIES

None known.

=head1 BUGS AND LIMITATIONS

This is an early release. Reports and suggestions will be warmly welcomed. 

Please report any issues to: 
L<https://github.com/Xiong/devel-toolbox/issues>.

=head1 DEVELOPMENT

This project is hosted on GitHub at: 
L<https://github.com/Xiong/devel-toolbox>. 

=head1 THANKS

Somebody helped!

=head1 AUTHOR

Xiong Changnian C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 
Xiong Changnian C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut





