use strict;
use warnings;

use Test::More;
use Devel::Toolbox::Core::Config::Master;       # Starting point for configs

# Compiled regexes
our $QRFALSE            = qr/\A0?\z/            ;
our $QRTRUE             = qr/\A(?!$QRFALSE)/    ;

#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#

my $tc          ;
my $base        = 'Devel::Toolbox::Core::Config::Master::get_master_paths(): ';
my $diag        = $base;
my @rv          ;
my $got         ;
my $want        ;

#----------------------------------------------------------------------------#

# Extra-verbose dump optional for test script debug.
my $Verbose     = 0;
#~    $Verbose++;




$diag   = $base . 'execute';
$tc++;
my $config  = Devel::Toolbox::Core::Config::Master::get_master_paths();
pass($diag);

note('Master config paths: ');
note(":$_") for @$config;
note('____');
exit;

#~ # Get template contents
#~ $diag   = $base . 'open-template-in-test';
#~ $tc++;
#~ $got    = open my $t_fh, '<', $template
#~             or 0;
#~ ok( $got, $diag );
#~ 
#~ $diag   = $base . 'slurp-template';
#~ $tc++;
#~ my $template_contents   ;
#~ {
#~     local $/            = undef;            # slurp
#~     $template_contents  = <$t_fh>;
#~ };
#~ $got    = $template_contents;
#~ ok( $got, $diag );
#~ 
#~ $diag   = $base . 'close-template-in-test';
#~ $tc++;
#~ $got    = close $t_fh
#~             or 0;
#~ ok( $got, $diag );
#~ 
#~ # Get new module contents.
#~ $diag   = $base . 'open-module-in-test';
#~ $tc++;
#~ $got    = open my $m_fh, '<', $module
#~             or 0;
#~ ok( $got, $diag );
#~ 
#~ $diag   = $base . 'slurp-module';
#~ $tc++;
#~ my $module_contents   ;
#~ {
#~     local $/            = undef;            # slurp
#~     $module_contents    = <$m_fh>;
#~ };
#~ $got    = $module_contents;
#~ ok( $got, $diag );
#~ 
#~ $diag   = $base . 'close-module-in-test';
#~ $tc++;
#~ $got    = close $m_fh
#~             or 0;
#~ ok( $got, $diag );
#~ 
#~ # Get compare contents
#~ $diag   = $base . 'open-compare-in-test';
#~ $tc++;
#~ $got    = open my $c_fh, '<', $compare
#~             or 0;
#~ ok( $got, $diag );
#~ 
#~ $diag   = $base . 'slurp-compare';
#~ $tc++;
#~ my $compare_contents   ;
#~ {
#~     local $/            = undef;            # slurp
#~     $compare_contents   = <$c_fh>;
#~ };
#~ $got    = $compare_contents;
#~ ok( $got, $diag );
#~ 
#~ $diag   = $base . 'close-compare-in-test';
#~ $tc++;
#~ $got    = close $c_fh
#~             or 0;
#~ ok( $got, $diag );
#~ 
#~ # For the big money -- exact match required
#~ $diag   = $base . 'is-module-eq-compare';
#~ $tc++;
#~ $got    = $module_contents;
#~ $want   = $compare_contents;
#~ is( $got, $want, $diag );

#----------------------------------------------------------------------------#

END {
    done_testing($tc);
    exit 0;
}

#============================================================================#

sub words {                         # sloppy match these strings
    my @words   = @_;
    my $regex   = q{};
    
    for (@words) {
        $_      = lc $_;
        $regex  = $regex . $_ . '.*';
    };
    
    return qr/$regex/is;
};

__DATA__

test
