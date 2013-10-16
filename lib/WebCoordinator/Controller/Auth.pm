package WebCoordinator::Controller::Auth;
use Moose;
use namespace::autoclean;
use WebCoordinator::Form::Login;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WebCoordinator::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub access_denied : Private {
    my ($self, $c) = @_;

    $c->stash(template => 'denied.tt2');
}

sub login :Global {
    my ($self, $c) = @_;

    my $form = WebCoordinator::Form::Login->new;
    $c->stash(form => $form);
    $form->process(params => $c->req->parameters);
    return unless $form->validated;

    if($c->authenticate( {username => $c->req->parameters->{user},
        password => $c->req->parameters->{password}})){
        $c->flash(message => 'Logged in successfully.');
        $c->res->redirect($c->uri_for('/'));
        $c->detach;
    }
    else {
        $c->stash(error => 'login failed');
        $c->res->redirect($c->uri_for('/'));
    }
}

sub logout :Global {
    my ($self, $c) = @_;
    $c->logout;
    $c->flash(message => 'Logged out');
    $c->res->redirect($c->uri_for('/'));
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched WebCoordinator::Controller::Auth in Auth.');
}


=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
