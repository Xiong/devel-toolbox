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
# EXECUTION

#=========# OBJECT METHOD
#~ 
#
#   @
#   
sub enforce {
    my $self        = shift;  
    my $case        = $self->{case}         // die "! No cases declared.";
#~     my $caller_script   = $self->{attr}{caller_script};
    my $caller_package  = $self->{attr}{caller_package};
    my $attr        = $self->{attr};
    my @case_keys   = keys $case;
    
    # Ignore disabled cases.
    @case_keys      = grep { $self->_is_enabled($_) } @case_keys;
    
    # A case hash is declared but let us enforce cases in predictable order.
    # You can alter this order by calling $self->sort(@keys)
    @case_keys      = $self->_do_sort( @case_keys );
    
    # Unpack case, execute, check.
    CASE_KEY:
    for my $case_key ( @case_keys ) {
        $self->{check_count}++;
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
                die "! Invalid context demanded: $context";
            }
        };
        
        # Store for possible later examination.
        $self->{case}{$case_key}{trap}      = $trap;
        
        # Do all checks for this case (as a subtest).
        subtest $case_key => sub {  # $case_key follows checks in TAP output
            pass('execute');
            my $want        = $i_case->{want}     // {};
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
                    $caller_package->$check_key(    # $_[0]     class, discard
                        $trap,                      # $_[1]     have
                        $want->{$check_key},        # $_[2]     want
                        $check_key,                 # $_[3]     diag
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
        
    }; ## for i_case
    
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





