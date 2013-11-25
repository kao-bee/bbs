package bbs2::DB;
use strict;
use warnings;
use utf8;
#use parent qw(Teng);

use Carp ();
use DBI;

#__PACKAGE__->load_plugin('Count');
#__PACKAGE__->load_plugin('Replace');
#__PACKAGE__->load_plugin('Pager');

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    my $self = bless {
        owner_pid    => $$,
        %args,
    }, $class;
    return $self;
}

sub dbh {
    my $self = shift;
    unless(defined $self->{_dbh}) {
        my $conf = $self->{connect_info};
        $self->{_dbh} = eval{ DBI->connect(@$conf) }
            or Carp::croak("Connection error: " . ($@ || $DBI::errstr));
    }
    return $self->{_dbh};
}

sub get_entry {
    my $self = shift;

    my $entries_ref = $self->dbh->selectall_arrayref(
        q{SELECT * FROM entry ORDER BY id ASC },
        {Slice => {}}
    );
}

sub insert_entry {
    my ($self, $body) = @_;

    my $sth = $self->dbh->prepare(
        qq{INSERT INTO entry (body) VALUE (?)}
    );

    $sth->execute($body);
}

1;
