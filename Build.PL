use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'App::War',
    license           => 'perl',
    dist_author       => 'John Trammell <johntrammell@gmail.com>',
    dist_version_from => 'lib/App/War.pm',
    requires => {
        'perl'                  => 0,
        'strict'                => 0,
        'warnings'              => 0,
        'Carp'                  => 0,
        'Data::Dumper'          => 0,
    },
    build_requires => {
        'strict'                => 0,
        'warnings'              => 0,
        'Test::More'            => 0,
        'Test::Script'          => 1.06,
        'Module::Build::Compat' => 0,
    },
    recursive_test_files => 1,
    add_to_cleanup       => [ qw/ Debian* App-War-* *.bak/ ],
);

$builder->create_build_script;

