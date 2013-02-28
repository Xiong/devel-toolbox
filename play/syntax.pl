#!/usr/bin/env perl
#       syntax.pl
#       = Copyright 2013 Xiong Changnian <xiong@cpan.org> =
#       = Free Software = Artistic License 2.0 = NO WARRANTY =

use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
use Error::Base;

# Define pool first! 
BEGIN {                         #    $::U or $main::U
    $::U      = {}; 
    say 'dt-BEGIN: ', $::U;
    # Make get_global_pool work now.
    use Devel::Toolbox::Core::Pool qw( -main );
    init_global_pool($::U);
}
use Devel::Toolbox;             # Simple custom project tool management
use Foo;

#~ use Devel::Comments '###';                                               #~
#~ use Devel::Comments '###', ({ -file => 'debug.log' });                   #~

## use
#============================================================================#

say "$0 Running...";





my $dead        = '42';
my $live        = \$dead;

# Declare sub and its code in one shot.
declare {
        -foo    => 'bar',
        -hoge   => 'piyo',
        -name   => 'fiddle',
        -sub    => 
sub{
    say '----[fiddle] Hey!';
}}; ## fiddle
# Close with two braces if you want to indent this way;
#  the entire thing is the argument to declare(). 

# Forward declaration, then 'declare', then define the sub's code. 
# This gives you a named sub inside your own package. 
sub plurky;                 # forward
declare {
        -foo    => 'baz',
        -hoge   => 'carmichael',
        -name   => 'plurky',
        -sub    => \&plurky,
};
sub plurky {
    say '----[plurky] zeep';
    say '$$live: ', $$live;     # both...
    say '$dead: ',   $dead;     #   ... work (not dead)
}; ## plurky

sub wonk {
    Foo::peepee();
};

# Execute. 
say 'main...';
plurky();
$dead++;

say 'wonking...';
wonk();

say "Done.";
exit 0;

#----------------------------------------------------------------------------#

sub munge {
    my $self        = shift;
    $self->{-attr}  = reverse $self->{-attr};
    return $self;
};

sub Screw::you {
    my $self        = shift;
    $self->{-attr}  = 'flipt';
    return $self;
};

#----------------------------------------------------------------------------#



sub new {
    my $class   = shift;
    my $self    = {};           # always hashref
    
    bless ($self => $class);
    $self->init(@_);            # init remaining args
    
    return $self;
}; ## new

sub init {
    my $self        = shift;
    my $args        = shift or return $self;
    %{$self}        = ( %{$self}, %{$args} );   # merge
    return $self;
}; ## init



#----------------------------------------------------------------------------#



#============================================================================#
__END__     
