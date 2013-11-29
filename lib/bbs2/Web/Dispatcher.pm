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
        my $responses_ref = $c->db->search_response_by_thread_id($thread->{id});
        $thread->{responses} = $responses_ref;
    }
    return $c->render('index.tx', {
            threads => $threads_ref,
    });
};

post '/api/thread' => sub {
    my ($c) = @_;

    my $subject = $c->req->param('subject');
    my $name = $c->req->param('name') || 'anonymous';
    my $body = $c->req->param('body') || '';

    return $c->render_json(+{response=>'false'}) unless defined $subject;

    my $thread_id = $c->db->add_thread($subject, $name);

    $c->db->add_response($thread_id, $body, $name);
    return $c->render_json(+{
            status=>200,
            thread_id=>$thread_id,
        });
};

post '/api/response' => sub {
    my ($c) = @_;
    my $thread_id = $c->req->param('thread-id');
    my $body = $c->req->param('body');
    my $name = $c->req->param('name');

    return $c->render_json(+{response => 'false'}) unless defined $thread_id && $body;

    $name //= 'anonymous';

    $c->db->add_response($thread_id, $body, $name);
    return $c->render_json(+{response => 'true'});
};

get '/api/thread' => sub {
    my ($c) = @_;
    my $thread_id = $c->req->param('thread_id');
    return $c->render_json({status=>500}) unless defined $thread_id;
    my $thread = $c->db->search_thread_by_id($thread_id);
    return $c->render_json({
            status => 200,
            thread => $thread,
        })
};

post '/thread' => sub {
    my ($c) = @_;

    my $subject = $c->req->param('subject');
    my $name = $c->req->param('name') || 'anonymous';
    my $body = $c->req->param('body') || '';

    return $c->redirect('/') unless defined $subject;

    $name //= 'anonymous';
    my $thread_id = $c->db->add_thread($subject, $name);

    $c->db->add_response($thread_id, $body, $name);
    return $c->redirect('/');
};

post '/response' => sub {
    my ($c) = @_;
    my $thread_id = $c->req->param('thread-id');
    my $body = $c->req->param('body');
    my $name = $c->req->param('name');

    return $c->redirect('/') unless defined $thread_id && $body;

    $name //= 'anonymous';

    $c->db->add_response($thread_id, $body, $name);
    return $c->redirect('/');
};
