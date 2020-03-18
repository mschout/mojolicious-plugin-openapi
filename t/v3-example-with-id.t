use Mojo::Base -strict;
use Test::Mojo;
use Test::More;
use Mojolicious::Lite;
use JSON::Validator::OpenAPI::Mojolicious;

get '/test' => sub {
  my $c = shift->openapi->valid_input or return;
  $c->render(status => 200, openapi => $c->param('pcversion'));
  },
  'File';

plugin OpenAPI => {schema => 'v3', url => app->home->rel_file("spec/v3-example_with_id.yaml")};

my $t = Test::Mojo->new;

my $json      = $t->get_ok('/api')->tx->res->body;
my $validator = JSON::Validator::OpenAPI::Mojolicious->new(version => 3);
is $validator->load_and_validate_schema($json, {schema => 'v3'}), $validator,
  'load_and_validate_schema; prove we get a valid spec';

done_testing;
