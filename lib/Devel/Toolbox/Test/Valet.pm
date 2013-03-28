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

# Project modules
use parent 'Devel::Toolbox::Core::Base';

# Alternate uses
use Devel::Comments '###', ({ -file => 'debug.log' });                   #~
### DTT-VALET

## use
#============================================================================#
# Pseudo-globals



## pseudo-globals
#----------------------------------------------------------------------------#

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub enforce {
    my $self        = shift;  
    my $cases       = $self->{case}     // die "! No test cases declared.";
    my $caller      = caller;           # calling package
    my $script      = $self->{script}   // $0;  # self-declared?
    
    # A hash is declared but we want to enforce in predictable order.
    my %sorter     = map { $_, $cases->{$_}{sort} || 0 } keys $cases; 
    my @sorted_case_keys = sort { $sorter{$a} cmp $sorter{$b} } keys %sorter;
    
    # Delete disabled cases.
    if ( exists $self->{enable} ) {     # if not then feature unused; skip
        if ( $self->{enable}{':all'} ) {    # disable only if case == false
            @sorted_case_keys 
                = grep { 
                    (
                        defined $self->{enable}{$_} 
                         && not $self->{enable}{$_}
                    )
                     ? 0 : 1 
                } @sorted_case_keys;
        }
        else {                              # enable only if case == true
            @sorted_case_keys 
                = grep { $self->{enable}{$_} } 
                    @sorted_case_keys;
        };
    }; ## if exists enable
    
    # Unpack case, execute, check.
    CASE_KEY:
    for my $case_key ( @sorted_case_keys ) {
        $self->{check_count}++;
        my $base        = _append( $script, $case_key );
        my $extra       ;
        my $diag        ;
        note( "---- $case_key:" );
        my $case        = $cases->{$case_key};
        my $context     = uc( $case->{context}  // 'SCALAR' );   # VOID, ARRAY
        my @args        = @{ $case->{args}      // []       };
        my $sub         = $case->{sub}          // 0        ;
        
        # Skip case if no code defined, eh.
        if ( not $sub ) {
            pass _append( $case_key, 'Skipped, no {sub} defined.' );
            next CASE_KEY;
        };
        
        # Execute code under test.
        given ($context) {
            when ( /VOID/   ) {
                             trap { &{ $case->{sub} }( @args ) };
            }
            when ( /ARRAY/  ) {
                my @array  = trap { &{ $case->{sub} }( @args ) };
            }
            when ( /SCALAR/ ) {
                my $scalar = trap { &{ $case->{sub} }( @args ) };
            }
            default         {
                die "! Invalid context demanded: $context";
            }
        };
        
        # Store for possible later examination.
        $self->{case}{$case_key}{trap}      = $trap;
        
        # Do all checks for this case (as a subtest).
        subtest $case_key => sub {  # $case_key follows checks in TAP output
            pass('execute');
            my $want        = $case->{want}     // {};
            if ( not $want ) {
                note _append( $case_key, 'Skipped, no {want} defined.' );
                done_testing(1);                # 1 subtest for 'execute'
                return;
            };
            my $sub_check_count;
            CHECK_KEY:
            for my $check_key ( keys $want ) {
#~                 ### $case_key
#~                 ### $check_key
#~                 ### $want
                $sub_check_count++;
                eval { 
                    $caller->$check_key( # class method; discard $_[0]
                        $trap,                  # $_[1]     got
                        $want->{$check_key},    # $_[2]     want
                        $check_key,             # $_[3]     diag
                    ) 
                };
                my $eval_err    = $@;
                if ($eval_err) {
                    diag("! Checker failure: $check_key");
                    fail( $eval_err );
                    next CHECK_KEY;
                };
            }; ## for check
        }; ## subtest
        
    }; ## for case
    
    return $self;
}; ## enforce

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub finish {
    my $self        = shift;
    ### finish()
    ### $self
     
    done_testing( $self->{check_count} );
    
    exit;       # NEVER RETURNS
}; ## finish

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

C<< <xiong@cpan.org> >>

=head1 LICENSE

Copyright (C) 2013 
C<< <xiong@cpan.org> >>

This library and its contents are released under Artistic License 2.0:

L<http://www.opensource.org/licenses/artistic-license-2.0.php>

=begin fool_pod_coverage

No, I'm not just lazy. I think it's counterproductive to give each accessor 
its very own section. Sorry if you disagree. 

=head2 put_attr

=head2 get_attr

=end   fool_pod_coverage

=cut





