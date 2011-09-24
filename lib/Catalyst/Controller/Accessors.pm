package Catalyst::Controller::Accessors;

use strict;
use warnings;

use Carp 'croak';

Moose::Exporter->setup_import_methods(
  with_meta => [ 'cat_has' ],
);

sub cat_has {
  my ( $meta, $name, %options ) = @_;

  my $is        = $options{is} || '';
  my $namespace = $options{namespace} || $meta->name;

  my $sub;
  if ($is eq 'ro') {
    $sub = sub { $_[1]->stash->{$namespace}{$name} };
  } elsif ($is eq 'rw') {
    $sub = sub {
      if (exists $_[2]) {
        $_[1]->stash->{$namespace}{$name} = $_[2]
      } else {
        return $_[1]->stash->{$namespace}{$name}
      }
    }
  } else {
    croak 'cat_has requires "is" to be "ro" or "rw"'
  }

  $meta->add_method( $name, $sub );
}

1;
