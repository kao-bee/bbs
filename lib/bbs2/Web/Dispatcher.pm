package bbs2::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my ($c) = @_;
#    my @entries = $c->db->get_entry;
    my $threads_ref = $c->db->get_threads;

    for my $thread (@$threads_ref) {
        my $responses_ref = $c->db->search_by_thread_id($thread->{id});
        $thread->{responses} = $responses_ref;
    }
    return $c->render('index.tx', {
            threads => $threads_ref,
    });
};

post '/create/thread' => sub {
    my ($c) = @_;

    if (my $subject = $c->req->param('subject')) {
        my $name //= 'no name';
        my $thread_id = $c->db->add_thread($subject, $name);

        my $body = $c->req->param('body') || '';

        $c->db->add_response($thread_id, $body, $name);
    }
    return $c->redirect('/');
};

post '/create/response' => sub {
    my ($c) = @_;
    my $thread_id = $c->req->param('thread-id');
    my $body = $c->req->param('body');
    my $name = $c->req->param('name');

    return $c->redirect('/') unless defined $thread_id && $body;

    $name //= 'anonymous';

    $c->db->add_response($thread_id, $body, $name);
    return $c->redirect('/');
}
