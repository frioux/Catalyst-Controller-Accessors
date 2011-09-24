use strict;
use warnings;

use lib 't/lib';
use Test::More;
use A::App;

my $app = A::App->new;
my $a = A::Controller::A->new;
my $b = A::Controller::B->new;

ok(!$a->a_list($app), 'value starts empty');
$a->a_list($app, '1,2,3');
is $a->a_list($app), '1,2,3', 'basic rw accessor works';
is $b->a_list($app), '1,2,3', 'initial namespaced rw accessor works';
$b->a_list($app, '3,2,1');
is $b->a_list($app), '3,2,1', 'namespaced rw accessor works';

ok(!$a->a_thing($app), 'value starts empty');
ok(!$b->a_thing($app), 'namespaced value starts empty');
$a->a_thing($app, '1,2,3');
ok(!$a->a_thing($app), 'ro value remains empty');
$b->a_thing($app, '1,2,3');
ok(!$b->a_thing($app), 'namespaced ro value remains empty');
$app->stash->{'A::Controller::A'}{'a_thing'} = 'brap';
is $a->a_thing($app), 'brap', 'accessor can still read correctly';
is $b->a_thing($app), 'brap', 'namespaced accessor can still read correctly';

done_testing;

BEGIN {
   package A::Controller::A;

   use Moose;
   use Catalyst::Controller::Accessors;

   cat_has a_list => (
      is => 'rw',
   );

   cat_has a_thing => (
      is => 'ro',
   );

   1;
}

BEGIN {
   package A::Controller::B;

   use Moose;
   use Catalyst::Controller::Accessors;

   cat_has a_list => (
      is => 'rw',
      namespace => 'A::Controller::A',
   );

   cat_has a_thing => (
      is => 'ro',
      namespace => 'A::Controller::A',
   );

   1;
}
