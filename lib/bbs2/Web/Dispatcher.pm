package bbs2::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my ($c) = @_;
#    my @entries = $c->db->get_entry;
    my $entries_ref = $c->db->get_entry;
    return $c->render('index.tx', {
            entries => $entries_ref,
    });
};

post '/post' => sub {
    my ($c) = @_;

    if (my $body = $c->req->param('body')) {
        $c->db->insert_entry($body);
    }
    return $c->redirect('/');
};

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
