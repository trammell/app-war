package App::War;
use strict;
use warnings FATAL => 'all';
use Graph;
use List::Util 'shuffle';

our $VERSION = 0.01;

=pod

=head1 NAME

App::War - turn a big decision into many small decisions

=head1 SYNOPSIS

    use App::War;
    my $war = App::War->new;
    $war->items(qw( this that the-other that-too ));

=head1 DESCRIPTION

=head1 METHODS

=head2 App::War->new()

=cut

sub new {
    my $class = shift;
    my $self = bless { @_ }, $class;
    return $self;
}

=head2 $war->graph

Returns the graph state object.  FIXME

=cut

sub graph {
    my $self = shift;
    $self->{graph} ||= Graph->new(directed => 1);
    return $self->{graph};
}

=head2 $war->items

=cut

sub items {
    my $self = shift;
    $self->{items} ||= [];
    if (@_) { $self->{items} = [ shuffle(@_) ]; }
    return @{ $self->{items} };
}

=head2 $war->nitems

=cut

sub nitems {
    my $self = shift;
    return scalar( $self->items );
}

=head2 $war->run

=cut

sub run {
    my $self = shift;
    my @items = $self->items;
    $self->_verb("Ranking items: @items");
    for (0 .. ($self->nitems - 1)) {
        $self->graph->add_vertex($_);
    }
    $self->_verb("graph vertices are: @{[ $self->graph->vertices ]}");
    while (my $ambiguous = $self->tsort_not_unique) {
        my ($u,$v) = @$ambiguous;
        $self->compare($u,$v);
    }
    print "Graph: ", $self->graph, "\n";
    my @ts = map { $items[$_] } $self->graph->topological_sort;
    print "ts: @ts\n";
}


=head2 $war->tsort_not_unique

# If a topological sort has the property that all pairs of consecutive vertices
# in the sorted order are connected by edges, then these edges form a directed
# Hamiltonian path in the DAG. If a Hamiltonian path exists, the topological
# sort order is unique; no other order respects the edges of the path.

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
    print "Choose one:\n";
    print "  1: $items[$x[0]]\n";
    print "  2: $items[$x[1]]\n";

    (my $foo = <STDIN>) =~ y/12//cd;

    if ($foo =~ /1/) {
        $self->graph->add_edge($x[0],$x[1]);
    }
    else {
        $self->graph->add_edge($x[1],$x[0]);
    }

}

sub _verb {
    my $self = shift;
    return unless $self->{verbose};
    warn "@_\n";
}

1;

