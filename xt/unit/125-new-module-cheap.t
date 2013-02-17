use strict;
use warnings;

use Test::More;
use File::Spec;                 # Portably perform operations on file names

use Devel::Toolbox;             # Simple custom project tool management
use Devel::Toolbox::Set::New;   # Create a project, module, test, or toolset

# Compiled regexes
our $QRFALSE            = qr/\A0?\z/            ;
our $QRTRUE             = qr/\A(?!$QRFALSE)/    ;

#----------------------------------------------------------------------------#


#----------------------------------------------------------------------------#

my $tc          ;
my $base        = 'Devel::Toolbox::Set::New::module(): ';
my $diag        = $base;
my @rv          ;
my $got         ;
my $want        ;

#----------------------------------------------------------------------------#

# Extra-verbose dump optional for test script debug.
my $Verbose     = 0;
#~    $Verbose++;

my $test_path   = File::Spec->catdir ( 'file', 'test' );
my $template    = File::Spec->catfile( $test_path, 'Module.pm' );
my $new_module  = File::Spec->catfile( $test_path, 'Example.pm' );

$diag   = $base . 'execute';
$tc++;
Devel::Toolbox::Set::New::module(

);
pass($diag);


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

