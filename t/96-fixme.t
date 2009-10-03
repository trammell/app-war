use Test::More;
eval 'use Test::Fixme';
my $f = 'FIX' . 'ME';
plan skip_all => "Test::Fixme required for $f tests" if $@;
run_tests();
