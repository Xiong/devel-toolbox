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

my $install_path    = File::Spec->catdir (qw( file install ));
my $test_path       = File::Spec->catdir ( 'test' );
my $template        = File::Spec->catfile( $install_path, 'Module.pm' );
my $module          = File::Spec->catfile( $test_path,    'Example.pm' );

my $self        = {
    -dist_name              => 'example-dist',
    -module_template        => $template,
    -template_delimiters    => [ '[% ', ' %]' ],
    -module_name            => 'Example',
    -module_abstract        => '.................. 44 chars in PAUSE upload!',
    -version                => 'v0.0.0',
    -author_name            => 'Alan Smithee',
    -author_email           => 'alan.smithee@example.org',
    -author_github          => 'Smithee',
    -tagquote               => 'Anyone can tell the truth, ' . qq{\n} 
                            . 'but only very few of us can make epigrams.',
    -tagquote_cite          => 'W. Somerset Maugham',
};


$diag   = $base . 'execute';
$tc++;
Devel::Toolbox::Set::New::module( $self, {
    -module             => $module,
});
pass($diag);

# Get template contents
$diag   = $base . 'open-template-in-test';
$tc++;
$got    = open my $tp_fh, '<', $template
            or 0;
ok( $got, $diag );

$diag   = $base . 'slurp-template';
$tc++;
my $template_contents   ;
{
    local $/            = undef;            # slurp
    $template_contents  = <$tp_fh>;
};
$got    = $template_contents;
ok( $got, $diag );

$diag   = $base . 'close-template-in-test';
$tc++;
$got    = close $tp_fh
            or 0;
ok( $got, $diag );

# Get new module contents.
$diag   = $base . 'open-module-in-test';
$tc++;
$got    = open my $m_fh, '<', $module
            or 0;
ok( $got, $diag );

$diag   = $base . 'slurp-module';
$tc++;
my $module_contents   ;
{
    local $/            = undef;            # slurp
    $module_contents    = <$m_fh>;
};
$got    = $module_contents;
ok( $got, $diag );

$diag   = $base . 'close-module-in-test';
$tc++;
$got    = close $m_fh
            or 0;
ok( $got, $diag );



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

