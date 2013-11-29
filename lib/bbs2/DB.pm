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

sub insert_thread_sth {
    my $self = shift;
    unless (defined $self->{_ins_th_sth}){
        $self->{_ins_th_sth} = $self->dbh->prepare(
            q{INSERT INTO threads (subject, name) VALUES (?,?)}
        );
    }
    return $self->{_ins_th_sth};
}

sub insert_response_sth {
    my $self = shift;
    unless (defined $self->{_ins_res_sth}) {
        $self->{_ins_res_sth} = $self->dbh->prepare(
            q{INSERT INTO responses (thread_id, body, name) VALUES (?,?,?)}
        );
    }
    return $self->{_ins_res_sth};
}

sub get_threads {
    my $self = shift;

    my $entries_ref = $self->dbh->selectall_arrayref(
        q{SELECT * FROM threads ORDER BY id DESC },
        {Slice => {}}
    );
}

sub search_response_by_thread_id {
    my ($self, $thread_id) = @_;
    my $responses_ref = $self->dbh->selectall_arrayref(
        qq{SELECT * FROM responses WHERE thread_id = $thread_id ORDER BY id ASC},
        {Slice => {}}
    );
}

sub insert_entry {
    my ($self, $body) = @_;

    my $sth = $self->dbh->prepare(
        qq{INSERT INTO threads (subject) VALUE (?)}
    );

    $sth->execute($body);
}

sub add_thread {
    my ($self, $subject, $name) = @_;

    $self->insert_thread_sth->execute($subject, $name);

    return $self->insert_thread_sth->{mysql_insertid};
}

sub add_response {
    my ($self, $thread_id, $body, $name) = @_;

    $self->insert_response_sth->execute($thread_id, $body, $name);
}

1;
