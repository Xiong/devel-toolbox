#!/usr/bin/env perl
use 5.016002;   # 5.16.2    # 2012  # __SUB__
use strict;
use warnings;

use lib 'play', 'lib';
use Alice;
use Mike;
use Bob;

print 'Alice: ';
Alice::run();

print 'Mike: ';
Mike::run();

print 'Bob: ';
Bob::run();








exit(0);
