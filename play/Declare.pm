package Declare;
use Exporter::Easy (            # Takes the drudgery out of Exporting symbols
    EXPORT      => [qw( declare as fiddle )],
);
use Devel::Comments '###';

#~ sub declare ($@) {
#~     my $decref      = shift;
#~     ### $decref
#~     my $as          = shift;
#~     if ($@) {
#~         local $_ = $@;
#~         &$as;
#~     }
#~ }
#~ 
#~ sub as (&) {
#~     my $coderef     = shift;
#~     &$coderef;
#~     
#~ }

sub declare {
    my $args        = shift;
    ### $args
    my $sub         = $args->{-coderef};
#~         &$sub;
}
sub as (&) { $_[0] }



1;
