#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use App::War;

our %OPT = ();
GetOptions(\%OPT,'help|h');

# get items
my @items = do {
    open(my $fh,q(<),$ARGV[0]) or die $!;
    grep { /\S/ && !/^#/ } map { chomp; $_ } <$fh>;
};

# run the war
my $war = App::War->new(items => \@items);
$war->run;

#FIXME: print the results



=pod

=head1 NAME

war - break one big decision into lots of little decisions

=head1 SYNOPSIS

    war [-h|--help]
    war --man
    war <sourcefile>

=head1 DESCRIPTIONS

=head1 ARGUMENTS

=cut

