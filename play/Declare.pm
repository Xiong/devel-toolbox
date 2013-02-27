package Declare;
use Exporter::Easy (            # Takes the drudgery out of Exporting symbols
    EXPORT      => [qw( declare $U )],
);
use Devel::Comments '###';

our $U  = {};     # pseudo-global store

sub declare {
    my $args                = shift;
    ### $args
    $U->{ $args->{-name} }  = $args->{-sub};
    ### $U
#~         &$sub;
}
#~ sub as (&) { $_[0] }

sub get_global_store {
    return $U;
};

1;
