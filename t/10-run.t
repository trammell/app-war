use Test::More tests => 2;
use_ok('App::War');

my $war = App::War->new();

# override methods "init", "rank", and "report"
my @methods = qw/ init rank report /;
my %count;
for my $m (@methods) {
    *{"App::War::$m"} = sub { $count{$m}++ };
}
$war->run;
is_deeply(\%count,{ map { $_ => 1 } @methods });