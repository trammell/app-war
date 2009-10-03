use strict;
use warnings FATAL => 'all';
use Test::More tests => 3;

use_ok('App::War');

my @items = qw{ apricot barista cargo duffle };

my $war = App::War->new(items => \@items)->init;
ok($war);

my $u = $war->tsort_not_unique;
ok($u);

