package WebCoordinator::Controller::Root;
use Moose;
use namespace::autoclean;
use Data::Dump::Streamer;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

WebCoordinator::Controller::Root - Root Controller for WebCoordinator

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    my $tr_data = $c->model('TestRunData');

    my $tt = $tr_data->get_all_testruns($c);
#    my $tref = eval { $tt };
 #   if($@) { $c->log->error($@); }
    $c->stash(testruns => $tt);

    my $str = Dump($tt)->Out();
    $c->stash(debug => $str);
}

sub modify :Path(/modify) :Args(1) {
    my ($self, $c, $tr_id) = @_;

    $c->log->info("modify: ");
    $c->model('TestRunData')->modify_testrun($c, $tr_id);
    $c->stash(template => 'index.tt2');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

wolf

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
