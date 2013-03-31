#!/usr/bin/env perl
#       ascii-sort.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
    no warnings 'numeric';

use lib qw| lib |;
use Error::Base;
use Perl6::Form;

#~ use Devel::Comments '###';
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

say "$0 Running...";

my @in           = qw|
    ahab
    ahaa
    aha
    az
    aa
    baz
    tuba
    tutu
    wheelwright
    0
    1
    18
    42
    4
    128
bigBoy bigbang bigboy x10y x9y x11y 
 5 1.01   1.3   1.02   1.2
 6 x1.1y x1.01y x2.3y x2.1y 
|;
my %sorter      ;
my @ok          ;

for (@in) {
    if ( $_ ne 0+$_ ) {                 # not exactly a number
        $sorter{$_}     = _numify($_);
    }
    else {
        $sorter{$_}     = $_;
    };
};

my @out_a2n     = sort { $sorter{$a} <=> $sorter{$b} } @in;
my @out_cmp     = sort { $a cmp $b } @in;

@ok             = map { $out_a2n[$_] eq $out_cmp[$_] ? 'OK' : '!!' } 
                    (0..$#out_cmp);
say
q* ==== NUMIFIED ======================================================     *;
say
q* $i   $out_cmp[$i]    $out_a2n[$i]    $sorter{$out_a2n[$i]}   $ok[$i]     *;
say
q* --------------------------------------------------------------------     *;

for my $i (0..$#in) {
    print form
q* {}   {<<<<<}         {<<<<<}         {>>>>>>>>>>>>>>>>>>>}   {}          *,
   $i,  $out_cmp[$i],   $out_a2n[$i],   $sorter{$out_a2n[$i]},  $ok[$i]     ,
;
};

# Alphafy any numbers instead.

%sorter     = ();   # clear

for (@in) {
    if ( $_ eq 0+$_ ) {                 # exactly a number
        $sorter{$_}      = _alphafy($_);
    }
    else {
        $sorter{$_}     = $_;
    };
};

my @out_n2a     = sort { $sorter{$a} cmp $sorter{$b} } @in;
my @out_ngc     = sort { $a <=> $b } @in;

@ok             = map { $out_n2a[$_] eq $out_ngc[$_] ? 'OK' : '!!' } 
                    (0..$#out_ngc);
say
q* ==== ALPHAFIED =====================================================     *;
say
q* $i   $out_ngc[$i]    $out_n2a[$i]    $sorter{$out_n2a[$i]}   $ok[$i]     *;
say
q* --------------------------------------------------------------------     *;

for my $i (0..$#in) {
    print form
q* {}   {<<<<<}         {<<<<<}         {>>>>>>>>>>>>>>>>>>>}   {}          *,
   $i,  $out_ngc[$i],   $out_n2a[$i],   $sorter{$out_n2a[$i]},  $ok[$i]     ,
;
};

# Dictify ~Tcl instead.

%sorter     = ();   # clear

for (@in) {
        $sorter{$_}     = _dictify($_);
};

my @out_tcl     = sort { $sorter{$a} cmp $sorter{$b} } @in;

say
q* ==== DICTIFIED =====================================================     *;
say
q* $i   $out_tcl[$i]                    $sorter{$out_tcl[$i]}               *;
say
q* --------------------------------------------------------------------     *;

for my $i (0..$#in) {
    print form
q* {}   {<<<<<}                         {>>>>>>>>>>>>>>>>>>>}               *,
   $i,  $out_tcl[$i],                   $sorter{$out_tcl[$i]},              ,
;
};


say "Done.";
exit;

#============================================================================#

sub _numify {
    my $string      = shift;
    my $natural     ;
    my $max         = 16;
    my $pad         ;
    my @scratch     ;
    
    @scratch        = unpack( 'C*', $string );
    @scratch        = map { $_ + 100 } @scratch;    # force three digits
#~     @scratch        = map { $_ } @scratch;    # without forcing
    $natural        = join q{}, @scratch;
    $pad            = $max - length $natural;
    warn "# $string is over $max chars"
        if $pad < 0;
    $natural        = $natural . ( q{0} x $pad );
    
    return $natural;
};

sub _alphafy {
    my $natural     = shift;
    my $string      ;
    my $max         = 16;
    my $pad         ;
    
    $pad            = $max - length $natural;
    warn "# $string is over $max chars"
        if $pad < 0;
    $string         = ( q{0} x $pad ) . $natural;
    
    return $string;
};

sub _dictify {
    my $in          = shift;
    my $string      ;
    my $pad         = '%08d';
#~ return $in;
    $string         = lc $in =~ s/(\d+)/sprintf $pad, $1/ger;
    
    return $string;
};
__END__     
