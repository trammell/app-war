use Test::More;
eval 'use Test::Fixme';
plan skip_all => 'Test::Fixme required for FIXME tests' if $@;
run_tests();
