package App::War;
use strict;
use warnings FATAL => 'all';
use Graph;
use List::Util 'shuffle';

our $VERSION = 0.01;

=pod

=head1 NAME

App::War - turn one big decision into many small decisions

=head1 SYNOPSIS

    use App::War;
    my $war = App::War->new;
    $war->items(qw/ this that the-other that-too /);
    $war->init;
    $war->rank;
    $war->report;

=head1 DESCRIPTION

Assume you need to rank a number of objects by preference.  One way to do
it is to compare the objects two at a time until a clear winner can be
established.

This module does just that, using a topological sort to establish a clear
ranking of all objects in the "war".

=head1 METHODS

=head2 App::War->new()

=cut

sub new {
    my $class = shift;
    my $self = bless { @_ }, $class;
    return $self;
}

=head2 $war->run

=cut

sub run {
    my $self = shift;
    $self->init;
    $self->rank;
    $self->report;
}

=head2 $war->init

Uses the content of C<< $self->items >> to initialize a graph containing
only vertices, one per item.

=cut

sub init {
    my $self = shift;
    my @items = $self->items;
    $self->_info("Ranking items: @items");
    my $g = $self->graph;
    for my $i (0 .. $#items) {
        $g->add_vertex($i);
    }
}

=head2 $war->report

Prints the current state of the graph.

=cut

sub report {
    my $self = shift;
    print "Graph: ", $self->graph, "\n";
    my @items = $self->items;
    my @ts = map { $items[$_] } $self->graph->topological_sort;
    print "ts: @ts\n";
}

=head2 $war->graph

Returns the graph object that stores the user choices.

=cut

sub graph {
    my $self = shift;
    unless ($self->{graph}) {
        $self->{graph} = Graph->new(directed => 1);
    }
    return $self->{graph};
}

=head2 $war->items

Get/set the items to be ranked.

=cut

sub items {
    my $self = shift;
    $self->{items} ||= [];
    if (@_) {
        $self->{items} = [ shuffle(@_) ];
    }
    return @{ $self->{items} };
}

=head2 $war->rank

=cut

sub rank {
    my $self = shift;
    while (my $v = $self->tsort_not_unique) {
        $self->compare($v->[0], $v->[1]);
    }
}

=head2 $war->tsort_not_unique

If the graph lacks a unique topological sort, this method returns a pair of
vertices that are currently ambiguous.

=over 4

If a topological sort has the property that all pairs of consecutive
vertices in the sorted order are connected by edges, then these edges form
a directed Hamiltonian path in the DAG. If a Hamiltonian path exists, the
topological sort order is unique; no other order respects the edges of the
path.

=back

=cut

sub tsort_not_unique {
    my $self = shift;
    my @ts = $self->graph->topological_sort;
    for my $i (0 .. $#ts - 1) {
        my ($u,$v) = @ts[$i,$i+1];
        next if $self->graph->has_edge($u,$v);
        return [$u,$v];
    }
    return 0;
}

=head2 $war->compare

=cut

sub compare {
    my ($self,@x) = @_;
    my @items = $self->items;
    print "Choose one of the following:\n";
    print "[1] $items[$x[0]]\n";
    print "[2] $items[$x[1]]\n";

    (my $foo = <STDIN>) =~ y/12//cd;

    my $g = $self->graph;
    if ($foo =~ /1/) {
        $g->add_edge($x[0],$x[1]);
    }
    else {
        $g->add_edge($x[1],$x[0]);
    }
}

sub _info {
    my $self = shift;
    if ($self->{verbose}) {
        warn "@_\n";
    }
}

1;

