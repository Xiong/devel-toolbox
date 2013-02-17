use Test::More tests => 1;

BEGIN {
    $SIG{__DIE__}   = sub {
        warn @_;
        BAIL_OUT( q[Couldn't use module; can't continue.] );    
        
    };
}   

BEGIN {
#
use Devel::Toolbox;             # Simple custom project tool management
use Devel::Toolbox::Set::New;   # Create a project, module, test, or toolset


#    
}

pass( 'Load modules.' );
diag( "Testing Devel::Toolbox $Devel::Toolbox::VERSION" );
