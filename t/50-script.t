use strict;
use warnings;
use Test::More tests => 2;
use Test::Script;
script_compiles('script/war','script/war compiles');
script_runs(['script/war','foo','bar'],'script/war runs');
