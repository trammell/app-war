package War;
use strict;
use warnings FATAL => 'all';
use Graph;

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

War->new->main unless caller;

sub new {
    my $class = shift;
    my $self = bless { @_ }, $class;
    $self->g(Graph->new(directed => 1));
    return $self;
}

sub main {
    my $self = shift;
    print "Items are: @{[ $self->items ]}\n";
    my @items = $self->items;
    for my $i (0 .. $#items) {
        $self->g->add_vertex($i);
    }
    $self->rank;
    print "Graph: ", $self->g, "\n";
    my @ts = map { $items[$_] } $self->g->topological_sort;
    print "ts: @ts\n";
}

sub g {
    my $self = shift;
    if (@_) { $self->{g} = shift; }
    return $self->{g};
}

sub items {
    my $self = shift;
    $self->{items} ||= do {
        open(my $fh,q(<),$ARGV[0]) or die $!;
        my @items = map { chomp; $_ } grep /\S/, <>;
        \@items;
    };
    return @{ $self->{items} };
}

sub rank {
    my $self = shift;

    while (my $v = $self->tsort_not_unique) {
        $self->compare($v->[0], $v->[1]);
    }
}

sub tsort_not_unique {

# If a topological sort has the property that all pairs of consecutive vertices
# in the sorted order are connected by edges, then these edges form a directed
# Hamiltonian path in the DAG. If a Hamiltonian path exists, the topological
# sort order is unique; no other order respects the edges of the path.

    my $self = shift;
    my @ts = $self->g->topological_sort;

    for my $i (0 .. $#ts - 1) {
        my ($u,$v) = @ts[$i,$i+1];
        next if $self->g->has_edge($u,$v);
        return [$u,$v];
    }

    return 0;
}


sub compare {
    my ($self,@x) = @_;
    my @items = $self->items;
    print "Choose one:\n";
    print "  1: $items[$x[0]]\n";
    print "  2: $items[$x[1]]\n";

    (my $foo = <STDIN>) =~ y/12//cd;

    if ($foo =~ /1/) {
        $self->g->add_edge($x[0],$x[1]);
    }
    else {
        $self->g->add_edge($x[1],$x[0]);
    }

}

1;

