package SlurpData;
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;
use version; our $VERSION = qv('v0.0.0');

#----------------------------------------------------------------------------#
# FUNCTIONS

#=========# EXTERNAL FUNCTION
#~     get();     # get default configuration
#
#   
#   
sub get {
    my $data    ;
#~     open DATA, '<', $file 
#~         or die 'Failed to open DATA for reading.';
    local $/        = undef;            # slurp
    $data           = <DATA>;
    close DATA 
        or die 'Failed to close DATA after reading.';
    return $data;
}; ## get

## END MODULE
1;
#============================================================================#
__END__

=pod

No docs!

=cut

__DATA__
hoge
piyo
